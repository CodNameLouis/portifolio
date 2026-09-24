import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/core/services/link_launcher.dart';
import 'package:portfolio_luan/features/projects/controllers/projects_event.dart';
import 'package:portfolio_luan/features/projects/controllers/projects_state.dart';
import 'package:portfolio_luan/features/projects/repositories/projects_repository.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  ProjectsBloc({required this.repository, required this.linkLauncher})
    : super(const ProjectsInitial()) {
    on<ProjectsStarted>(_onStarted);
    on<ProjectsFilterChanged>(_onFilterChanged);
    on<ProjectOpened>(_onProjectOpened);
  }

  final ProjectsRepository repository;
  final LinkLauncher linkLauncher;

  Future<void> _onStarted(
    ProjectsStarted event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(const ProjectsLoading());

    try {
      emit(ProjectsLoaded(projects: await repository.fetchAll()));
    } on AppFailure catch (failure) {
      emit(ProjectsFailure(failure));
    } on Object {
      emit(const ProjectsFailure(AppFailure.load()));
    }
  }

  void _onFilterChanged(
    ProjectsFilterChanged event,
    Emitter<ProjectsState> emit,
  ) {
    final state = this.state;

    if (state is! ProjectsLoaded) {
      return;
    }

    emit(state.copyWith(selectedCategory: event.category));
  }

  Future<void> _onProjectOpened(
    ProjectOpened event,
    Emitter<ProjectsState> emit,
  ) async {
    final state = this.state;

    if (state is! ProjectsLoaded) {
      return;
    }

    final opened = await linkLauncher.open(event.project.url);

    if (opened) {
      return;
    }

    emit(state.copyWith(launchFailure: const AppFailure.link()));
  }
}
