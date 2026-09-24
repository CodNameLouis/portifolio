import 'package:equatable/equatable.dart';
import 'package:portfolio_luan/features/projects/models/project_category.dart';
import 'package:portfolio_luan/features/projects/models/project_model.dart';

sealed class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  @override
  List<Object?> get props => [];
}

final class ProjectsStarted extends ProjectsEvent {
  const ProjectsStarted();
}

final class ProjectsFilterChanged extends ProjectsEvent {
  const ProjectsFilterChanged(this.category);

  final ProjectCategory category;

  @override
  List<Object?> get props => [category];
}

final class ProjectOpened extends ProjectsEvent {
  const ProjectOpened(this.project);

  final ProjectModel project;

  @override
  List<Object?> get props => [project];
}
