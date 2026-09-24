import 'package:equatable/equatable.dart';
import 'package:portfolio_luan/features/stack/models/skill_group_model.dart';
import 'package:portfolio_luan/features/stack/models/stack_highlight_model.dart';

class StackModel extends Equatable {
  const StackModel({required this.highlight, required this.groups});

  factory StackModel.fromJson(Map<String, dynamic> json) {
    final rawHighlight = json['highlight'] as Map<String, dynamic>?;
    final rawGroups = json['groups'] as List<dynamic>? ?? const [];

    return StackModel(
      highlight: rawHighlight == null
          ? null
          : StackHighlightModel.fromJson(rawHighlight),
      groups: rawGroups
          .whereType<Map<String, dynamic>>()
          .map(SkillGroupModel.fromJson)
          .toList(growable: false),
    );
  }

  final StackHighlightModel? highlight;
  final List<SkillGroupModel> groups;

  @override
  List<Object?> get props => [highlight, groups];
}
