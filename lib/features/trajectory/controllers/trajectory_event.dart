import 'package:equatable/equatable.dart';

sealed class TrajectoryEvent extends Equatable {
  const TrajectoryEvent();

  @override
  List<Object?> get props => [];
}

final class TrajectoryStarted extends TrajectoryEvent {
  const TrajectoryStarted();
}
