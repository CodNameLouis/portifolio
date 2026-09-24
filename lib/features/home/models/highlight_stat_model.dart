import 'package:equatable/equatable.dart';

class HighlightStatModel extends Equatable {
  const HighlightStatModel({
    required this.title,
    required this.subtitle,
    required this.emphasis,
  });

  factory HighlightStatModel.fromJson(Map<String, dynamic> json) {
    return HighlightStatModel(
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      emphasis: json['emphasis'] as bool? ?? false,
    );
  }

  final String title;
  final String subtitle;
  final bool emphasis;

  @override
  List<Object?> get props => [title, subtitle, emphasis];
}
