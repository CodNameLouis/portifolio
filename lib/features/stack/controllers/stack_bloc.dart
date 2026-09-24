import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/features/stack/controllers/stack_event.dart';
import 'package:portfolio_luan/features/stack/controllers/stack_state.dart';
import 'package:portfolio_luan/features/stack/repositories/stack_repository.dart';

class StackBloc extends Bloc<StackEvent, StackState> {
  StackBloc({required this.repository}) : super(const StackInitial()) {
    on<StackStarted>(_onStarted);
  }

  final StackRepository repository;

  Future<void> _onStarted(StackStarted event, Emitter<StackState> emit) async {
    emit(const StackLoading());

    try {
      emit(StackLoaded(await repository.fetch()));
    } on AppFailure catch (failure) {
      emit(StackFailure(failure));
    } on Object {
      emit(const StackFailure(AppFailure.load()));
    }
  }
}
