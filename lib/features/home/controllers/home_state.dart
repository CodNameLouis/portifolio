import 'package:equatable/equatable.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/features/home/models/profile_model.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded(this.profile);

  final ProfileModel profile;

  @override
  List<Object?> get props => [profile];
}

final class HomeFailure extends HomeState {
  const HomeFailure(this.failure);

  final AppFailure failure;

  @override
  List<Object?> get props => [failure];
}
