import 'package:equatable/equatable.dart';

class EducationModel extends Equatable {
  const EducationModel({required this.course, required this.detail});

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      course: json['course'] as String? ?? '',
      detail: json['detail'] as String? ?? '',
    );
  }

  final String course;
  final String detail;

  @override
  List<Object?> get props => [course, detail];
}
