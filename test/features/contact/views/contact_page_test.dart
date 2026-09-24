import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/core/services/link_launcher.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/core/theme/app_theme.dart';
import 'package:portfolio_luan/features/contact/controllers/contact_bloc.dart';
import 'package:portfolio_luan/features/contact/controllers/contact_event.dart';
import 'package:portfolio_luan/features/contact/models/contact_link_model.dart';
import 'package:portfolio_luan/features/contact/models/contact_link_type.dart';
import 'package:portfolio_luan/features/contact/models/contact_model.dart';
import 'package:portfolio_luan/features/contact/repositories/contact_repository.dart';
import 'package:portfolio_luan/features/contact/views/contact_page.dart';
import 'package:portfolio_luan/features/contact/views/widgets/contact_link_tile.dart';
import 'package:portfolio_luan/features/contact/views/widgets/resume_button.dart';
import 'package:portfolio_luan/shared/widgets/feedback/error_view.dart';

class _MockContactRepository extends Mock implements ContactRepository {}

class _MockLinkLauncher extends Mock implements LinkLauncher {}

void main() {
  late _MockContactRepository repository;
  late _MockLinkLauncher linkLauncher;

  const contact = ContactModel(
    title: 'Vamos tirar seu app do papel?',
    subtitle: 'Disponibilidade imediata · 100% remoto',
    links: [
      ContactLinkModel(
        type: ContactLinkType.email,
        label: 'E-mail',
        value: 'luan@afcinfotelecom.net',
        url: 'mailto:luan@afcinfotelecom.net',
      ),
      ContactLinkModel(
        type: ContactLinkType.github,
        label: 'GitHub',
        value: 'CodNameLouis',
        url: 'https://github.com/CodNameLouis',
      ),
    ],
    resumeUrl: 'https://exemplo.com/curriculo.pdf',
  );

  setUp(() {
    repository = _MockContactRepository();
    linkLauncher = _MockLinkLauncher();
    when(repository.fetch).thenAnswer((_) async => contact);
    when(() => linkLauncher.open(any())).thenAnswer((_) async => true);
  });

  Future<void> pumpPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: Scaffold(
          body: BlocProvider(
            create: (context) =>
                ContactBloc(repository: repository, linkLauncher: linkLauncher)
                  ..add(const ContactStarted()),
            child: const ContactPage(),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('mostra hero, links e botão de currículo', (tester) async {
    await pumpPage(tester);

    expect(find.text(contact.title), findsOneWidget);
    expect(find.text(contact.subtitle), findsOneWidget);

    expect(find.byType(ContactLinkTile), findsNWidgets(2));
    expect(find.text('E-mail'), findsOneWidget);
    expect(find.text('luan@afcinfotelecom.net'), findsOneWidget);
    expect(find.text('CodNameLouis'), findsOneWidget);

    expect(find.byType(ResumeButton), findsOneWidget);
    expect(find.text(AppStrings.contactResumeButton), findsOneWidget);
  });

  testWidgets('escreve os textos em branco, sobre a paleta terracota', (
    tester,
  ) async {
    await pumpPage(tester);

    final titulo = tester.widget<Text>(find.text(contact.title));
    expect(titulo.style?.color, AppColors.white);

    final valor = tester.widget<Text>(find.text('CodNameLouis'));
    expect(valor.style?.color, AppColors.white);
  });

  testWidgets('tocar no link chama o launcher com a URL do link', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.tap(find.text('CodNameLouis'));
    await tester.pump();

    verify(
      () => linkLauncher.open('https://github.com/CodNameLouis'),
    ).called(1);
  });

  testWidgets('tocar no currículo usa o resumeUrl', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.text(AppStrings.contactResumeButton));
    await tester.pump();

    verify(() => linkLauncher.open(contact.resumeUrl)).called(1);
  });

  testWidgets('link que não abre mostra SnackBar', (tester) async {
    when(() => linkLauncher.open(any())).thenAnswer((_) async => false);

    await pumpPage(tester);

    await tester.tap(find.text('CodNameLouis'));
    await tester.pump();
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(AppStrings.failureLink), findsOneWidget);
  });

  testWidgets('link que abre não mostra SnackBar', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.text('CodNameLouis'));
    await tester.pump();
    await tester.pump();

    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('mostra ErrorView quando o repositório falha', (tester) async {
    when(repository.fetch).thenThrow(const AppFailure.load());

    await pumpPage(tester);

    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text(AppStrings.failureLoad), findsOneWidget);
  });
}
