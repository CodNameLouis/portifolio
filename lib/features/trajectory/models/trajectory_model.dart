import 'package:equatable/equatable.dart';
import 'package:portfolio_luan/features/trajectory/models/education_model.dart';
import 'package:portfolio_luan/features/trajectory/models/experience_model.dart';

class TrajectoryModel extends Equatable {
  const TrajectoryModel({required this.experiences, required this.education});

  factory TrajectoryModel.fromJson(Map<String, dynamic> json) {
    final rawExperiences = json['experiences'] as List<dynamic>? ?? const [];
    final rawEducation = json['education'] as List<dynamic>? ?? const [];

    return TrajectoryModel(
      experiences: rawExperiences
          .whereType<Map<String, dynamic>>()
          .map(ExperienceModel.fromJson)
          .toList(growable: false),
      education: rawEducation
          .whereType<Map<String, dynamic>>()
          .map(EducationModel.fromJson)
          .toList(growable: false),
    );
  }

  final List<ExperienceModel> experiences;
  final List<EducationModel> education;

  @override
  List<Object?> get props => [experiences, education];
}
