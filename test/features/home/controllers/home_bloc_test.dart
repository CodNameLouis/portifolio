import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/features/home/controllers/home_bloc.dart';
import 'package:portfolio_luan/features/home/controllers/home_event.dart';
import 'package:portfolio_luan/features/home/controllers/home_state.dart';
import 'package:portfolio_luan/features/home/models/highlight_stat_model.dart';
import 'package:portfolio_luan/features/home/models/profile_model.dart';
import 'package:portfolio_luan/features/home/repositories/profile_repository.dart';

class _MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late _MockProfileRepository repository;

  const profile = ProfileModel(
    firstName: 'Luan Nunes',
    lastName: 'Caldeira',
    greeting: 'Olá, eu sou',
    role: 'Desenvolvedor Flutter Pleno/Sênior',
    bio: 'Crio apps mobile.',
    available: true,
    availabilityLabel: 'Disponível agora',
    photo: 'assets/images/profile.jpg',
    stats: [
      HighlightStatModel(
        title: '4+ anos',
        subtitle: 'com Flutter & Dart',
        emphasis: true,
      ),
    ],
  );

  setUp(() {
    repository = _MockProfileRepository();
  });

  blocTest<HomeBloc, HomeState>(
    'emite Loading e Loaded quando o repositório responde',
    setUp: () {
      when(repository.fetch).thenAnswer((_) async => profile);
    },
    build: () => HomeBloc(repository: repository),
    act: (bloc) => bloc.add(const HomeStarted()),
    expect: () => const [HomeLoading(), HomeLoaded(profile)],
  );

  blocTest<HomeBloc, HomeState>(
    'emite Loading e Failure quando o repositório falha',
    setUp: () {
      when(repository.fetch).thenThrow(const AppFailure.parse());
    },
    build: () => HomeBloc(repository: repository),
    act: (bloc) => bloc.add(const HomeStarted()),
    expect: () => const [HomeLoading(), HomeFailure(AppFailure.parse())],
  );

  blocTest<HomeBloc, HomeState>(
    'converte erro inesperado em AppFailure.load',
    setUp: () {
      when(repository.fetch).thenThrow(Exception('erro qualquer'));
    },
    build: () => HomeBloc(repository: repository),
    act: (bloc) => bloc.add(const HomeStarted()),
    expect: () => const [HomeLoading(), HomeFailure(AppFailure.load())],
  );

  blocTest<HomeBloc, HomeState>(
    'recarrega ao receber HomeStarted de novo',
    setUp: () {
      when(repository.fetch).thenAnswer((_) async => profile);
    },
    build: () => HomeBloc(repository: repository),
    act: (bloc) => bloc
      ..add(const HomeStarted())
      ..add(const HomeStarted()),
    expect: () => const [
      HomeLoading(),
      HomeLoaded(profile),
      HomeLoading(),
      HomeLoaded(profile),
    ],
  );
}
