import 'package:equatable/equatable.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';

enum AppFailureType { load, parse, link }

class AppFailure extends Equatable implements Exception {
  const AppFailure({required this.type, required this.message});

  const AppFailure.load({this.message = AppStrings.failureLoad})
    : type = AppFailureType.load;

  const AppFailure.parse({this.message = AppStrings.failureParse})
    : type = AppFailureType.parse;

  const AppFailure.link({this.message = AppStrings.failureLink})
    : type = AppFailureType.link;

  final AppFailureType type;
  final String message;

  @override
  List<Object?> get props => [type, message];
}
