import 'package:equatable/equatable.dart';

class StackHighlightModel extends Equatable {
  const StackHighlightModel({
    required this.title,
    required this.subtitle,
    required this.level,
  });

  factory StackHighlightModel.fromJson(Map<String, dynamic> json) {
    return StackHighlightModel(
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      level: json['level'] as String? ?? '',
    );
  }

  final String title;
  final String subtitle;
  final String level;

  @override
  List<Object?> get props => [title, subtitle, level];
}
