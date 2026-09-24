import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/features/trajectory/controllers/trajectory_event.dart';
import 'package:portfolio_luan/features/trajectory/controllers/trajectory_state.dart';
import 'package:portfolio_luan/features/trajectory/repositories/trajectory_repository.dart';

class TrajectoryBloc extends Bloc<TrajectoryEvent, TrajectoryState> {
  TrajectoryBloc({required this.repository})
    : super(const TrajectoryInitial()) {
    on<TrajectoryStarted>(_onStarted);
  }

  final TrajectoryRepository repository;

  Future<void> _onStarted(
    TrajectoryStarted event,
    Emitter<TrajectoryState> emit,
  ) async {
    emit(const TrajectoryLoading());

    try {
      emit(TrajectoryLoaded(await repository.fetch()));
    } on AppFailure catch (failure) {
      emit(TrajectoryFailure(failure));
    } on Object {
      emit(const TrajectoryFailure(AppFailure.load()));
    }
  }
}
