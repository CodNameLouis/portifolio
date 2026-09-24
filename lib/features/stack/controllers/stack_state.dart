import 'package:equatable/equatable.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/features/stack/models/stack_model.dart';

sealed class StackState extends Equatable {
  const StackState();

  @override
  List<Object?> get props => [];
}

final class StackInitial extends StackState {
  const StackInitial();
}

final class StackLoading extends StackState {
  const StackLoading();
}

final class StackLoaded extends StackState {
  const StackLoaded(this.stack);

  final StackModel stack;

  @override
  List<Object?> get props => [stack];
}

final class StackFailure extends StackState {
  const StackFailure(this.failure);

  final AppFailure failure;

  @override
  List<Object?> get props => [failure];
}
