import 'package:equatable/equatable.dart';

class ExperienceModel extends Equatable {
  const ExperienceModel({
    required this.period,
    required this.role,
    required this.company,
    required this.mode,
    required this.description,
    required this.current,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      period: json['period'] as String? ?? '',
      role: json['role'] as String? ?? '',
      company: json['company'] as String? ?? '',
      mode: json['mode'] as String? ?? '',
      description: json['description'] as String? ?? '',
      current: json['current'] as bool? ?? false,
    );
  }

  final String period;
  final String role;
  final String company;
  final String mode;
  final String description;
  final bool current;

  @override
  List<Object?> get props => [
    period,
    role,
    company,
    mode,
    description,
    current,
  ];
}
