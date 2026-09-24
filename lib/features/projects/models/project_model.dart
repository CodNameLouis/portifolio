import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_luan/core/theme/app_colors.dart';
import 'package:portfolio_luan/features/projects/models/project_category.dart';

class ProjectModel extends Equatable {
  const ProjectModel({
    required this.id,
    required this.name,
    required this.client,
    required this.summary,
    required this.roles,
    required this.tags,
    required this.categories,
    required this.featured,
    required this.rating,
    required this.ratingCount,
    required this.thumbColor,
    required this.icon,
    required this.screenshot,
    required this.url,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      client: json['client'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      roles: _stringList(json['roles']),
      tags: _stringList(json['tags']),
      categories: _stringList(
        json['categories'],
      ).map(ProjectCategory.fromKey).nonNulls.toList(growable: false),
      featured: json['featured'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
      thumbColor: colorFromToken(json['thumbColor'] as String?),
      icon: json['icon'] as String? ?? '',
      screenshot: json['screenshot'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  static const Map<String, Color> thumbColors = {
    'navy': AppColors.navy,
    'mustard': AppColors.mustard,
    'terracotta': AppColors.terracotta,
  };

  final String id;
  final String name;
  final String client;
  final String summary;
  final List<String> roles;
  final List<String> tags;
  final List<ProjectCategory> categories;
  final bool featured;
  final double rating;
  final int ratingCount;
  final Color thumbColor;
  final String icon;
  final String screenshot;
  final String url;

  static Color colorFromToken(String? token) =>
      thumbColors[token] ?? AppColors.navy;

  static List<String> _stringList(Object? value) {
    if (value is! List) {
      return const [];
    }

    return value.whereType<String>().toList(growable: false);
  }

  bool matches(ProjectCategory category) =>
      category == ProjectCategory.all || categories.contains(category);

  @override
  List<Object?> get props => [
    id,
    name,
    client,
    summary,
    roles,
    tags,
    categories,
    featured,
    rating,
    ratingCount,
    thumbColor,
    icon,
    screenshot,
    url,
  ];
}
