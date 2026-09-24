import 'package:equatable/equatable.dart';

sealed class StackEvent extends Equatable {
  const StackEvent();

  @override
  List<Object?> get props => [];
}

final class StackStarted extends StackEvent {
  const StackStarted();
}
