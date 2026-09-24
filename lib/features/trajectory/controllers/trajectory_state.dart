import 'package:equatable/equatable.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/features/trajectory/models/trajectory_model.dart';

sealed class TrajectoryState extends Equatable {
  const TrajectoryState();

  @override
  List<Object?> get props => [];
}

final class TrajectoryInitial extends TrajectoryState {
  const TrajectoryInitial();
}

final class TrajectoryLoading extends TrajectoryState {
  const TrajectoryLoading();
}

final class TrajectoryLoaded extends TrajectoryState {
  const TrajectoryLoaded(this.trajectory);

  final TrajectoryModel trajectory;

  @override
  List<Object?> get props => [trajectory];
}

final class TrajectoryFailure extends TrajectoryState {
  const TrajectoryFailure(this.failure);

  final AppFailure failure;

  @override
  List<Object?> get props => [failure];
}
