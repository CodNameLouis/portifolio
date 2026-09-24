import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/features/home/controllers/home_event.dart';
import 'package:portfolio_luan/features/home/controllers/home_state.dart';
import 'package:portfolio_luan/features/home/repositories/profile_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this.repository}) : super(const HomeInitial()) {
    on<HomeStarted>(_onStarted);
  }

  final ProfileRepository repository;

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());

    try {
      emit(HomeLoaded(await repository.fetch()));
    } on AppFailure catch (failure) {
      emit(HomeFailure(failure));
    } on Object {
      emit(const HomeFailure(AppFailure.load()));
    }
  }
}
