import 'package:portfolio_luan/features/projects/models/project_model.dart';

abstract interface class ProjectsRepository {
  Future<List<ProjectModel>> fetchAll();
}
