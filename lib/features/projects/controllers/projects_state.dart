import 'package:equatable/equatable.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/features/projects/models/project_category.dart';
import 'package:portfolio_luan/features/projects/models/project_model.dart';

sealed class ProjectsState extends Equatable {
  const ProjectsState();

  @override
  List<Object?> get props => [];
}

final class ProjectsInitial extends ProjectsState {
  const ProjectsInitial();
}

final class ProjectsLoading extends ProjectsState {
  const ProjectsLoading();
}

final class ProjectsLoaded extends ProjectsState {
  const ProjectsLoaded({
    required this.projects,
    this.selectedCategory = ProjectCategory.all,
    this.launchFailure,
  });

  final List<ProjectModel> projects;
  final ProjectCategory selectedCategory;
  final AppFailure? launchFailure;

  List<ProjectModel> get visible => projects
      .where((project) => project.matches(selectedCategory))
      .toList(growable: false);

  ProjectModel? get featured {
    for (final project in visible) {
      if (project.featured) {
        return project;
      }
    }

    return null;
  }

  List<ProjectModel> get others {
    final highlighted = featured;

    return visible
        .where((project) => project != highlighted)
        .toList(growable: false);
  }

  ProjectsLoaded copyWith({
    ProjectCategory? selectedCategory,
    AppFailure? launchFailure,
  }) {
    return ProjectsLoaded(
      projects: projects,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      launchFailure: launchFailure,
    );
  }

  @override
  List<Object?> get props => [projects, selectedCategory, launchFailure];
}

final class ProjectsFailure extends ProjectsState {
  const ProjectsFailure(this.failure);

  final AppFailure failure;

  @override
  List<Object?> get props => [failure];
}
