import 'package:equatable/equatable.dart';

class SkillGroupModel extends Equatable {
  const SkillGroupModel({required this.label, required this.items});

  factory SkillGroupModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? const [];

    return SkillGroupModel(
      label: json['label'] as String? ?? '',
      items: rawItems.whereType<String>().toList(growable: false),
    );
  }

  final String label;
  final List<String> items;

  @override
  List<Object?> get props => [label, items];
}
