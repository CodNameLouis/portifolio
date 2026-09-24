import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/core/services/link_launcher.dart';
import 'package:portfolio_luan/features/contact/controllers/contact_bloc.dart';
import 'package:portfolio_luan/features/contact/controllers/contact_event.dart';
import 'package:portfolio_luan/features/contact/controllers/contact_state.dart';
import 'package:portfolio_luan/features/contact/models/contact_link_model.dart';
import 'package:portfolio_luan/features/contact/models/contact_link_type.dart';
import 'package:portfolio_luan/features/contact/models/contact_model.dart';
import 'package:portfolio_luan/features/contact/repositories/contact_repository.dart';

class _MockContactRepository extends Mock implements ContactRepository {}

class _MockLinkLauncher extends Mock implements LinkLauncher {}

void main() {
  late _MockContactRepository repository;
  late _MockLinkLauncher linkLauncher;

  const emailUrl = 'mailto:luan@afcinfotelecom.net';

  const email = ContactLinkModel(
    type: ContactLinkType.email,
    label: 'E-mail',
    value: 'luan@afcinfotelecom.net',
    url: emailUrl,
  );

  const contact = ContactModel(
    title: 'Vamos tirar seu app do papel?',
    subtitle: 'Disponibilidade imediata · 100% remoto',
    links: [email],
    resumeUrl: 'https://exemplo.com/curriculo.pdf',
  );

  setUp(() {
    repository = _MockContactRepository();
    linkLauncher = _MockLinkLauncher();
  });

  ContactBloc build() =>
      ContactBloc(repository: repository, linkLauncher: linkLauncher);

  blocTest<ContactBloc, ContactState>(
    'emite Loading e Loaded quando o repositório responde',
    setUp: () {
      when(repository.fetch).thenAnswer((_) async => contact);
    },
    build: build,
    act: (bloc) => bloc.add(const ContactStarted()),
    expect: () => const [ContactLoading(), ContactLoaded(contact: contact)],
  );

  blocTest<ContactBloc, ContactState>(
    'emite Failure quando o repositório falha',
    setUp: () {
      when(repository.fetch).thenThrow(const AppFailure.parse());
    },
    build: build,
    act: (bloc) => bloc.add(const ContactStarted()),
    expect: () => const [ContactLoading(), ContactFailure(AppFailure.parse())],
  );

  blocTest<ContactBloc, ContactState>(
    'abrir link com sucesso não emite estado novo',
    setUp: () {
      when(repository.fetch).thenAnswer((_) async => contact);
      when(() => linkLauncher.open(any())).thenAnswer((_) async => true);
    },
    build: build,
    act: (bloc) => bloc
      ..add(const ContactStarted())
      ..add(const ContactLinkPressed(emailUrl)),
    skip: 2,
    expect: () => const <ContactState>[],
    verify: (_) {
      verify(() => linkLauncher.open(emailUrl)).called(1);
    },
  );

  blocTest<ContactBloc, ContactState>(
    'falha ao abrir link emite launchFailure',
    setUp: () {
      when(repository.fetch).thenAnswer((_) async => contact);
      when(() => linkLauncher.open(any())).thenAnswer((_) async => false);
    },
    build: build,
    act: (bloc) => bloc
      ..add(const ContactStarted())
      ..add(const ContactLinkPressed(emailUrl)),
    skip: 2,
    expect: () => const [
      ContactLoaded(contact: contact, launchFailure: AppFailure.link()),
    ],
  );

  blocTest<ContactBloc, ContactState>(
    'currículo usa o resumeUrl do model',
    setUp: () {
      when(repository.fetch).thenAnswer((_) async => contact);
      when(() => linkLauncher.open(any())).thenAnswer((_) async => true);
    },
    build: build,
    act: (bloc) => bloc
      ..add(const ContactStarted())
      ..add(const ResumeDownloadPressed()),
    skip: 2,
    expect: () => const <ContactState>[],
    verify: (_) {
      verify(() => linkLauncher.open(contact.resumeUrl)).called(1);
    },
  );

  blocTest<ContactBloc, ContactState>(
    'falha ao baixar o currículo emite launchFailure',
    setUp: () {
      when(repository.fetch).thenAnswer((_) async => contact);
      when(() => linkLauncher.open(any())).thenAnswer((_) async => false);
    },
    build: build,
    act: (bloc) => bloc
      ..add(const ContactStarted())
      ..add(const ResumeDownloadPressed()),
    skip: 2,
    expect: () => const [
      ContactLoaded(contact: contact, launchFailure: AppFailure.link()),
    ],
  );

  blocTest<ContactBloc, ContactState>(
    'ignora toque em link antes dos dados chegarem',
    build: build,
    act: (bloc) => bloc.add(const ContactLinkPressed(emailUrl)),
    expect: () => const <ContactState>[],
    verify: (_) {
      verifyNever(() => linkLauncher.open(any()));
    },
  );
}
