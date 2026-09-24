import 'package:portfolio_luan/core/constants/app_assets.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/core/services/json_asset_loader.dart';
import 'package:portfolio_luan/features/projects/models/project_model.dart';
import 'package:portfolio_luan/features/projects/repositories/projects_repository.dart';

class LocalProjectsRepository implements ProjectsRepository {
  const LocalProjectsRepository({required this.loader});

  final JsonAssetLoader loader;

  @override
  Future<List<ProjectModel>> fetchAll() async {
    final json = await loader.load(AppAssets.projectsJson);

    try {
      final raw = json['projects'] as List<dynamic>? ?? const [];

      return raw
          .whereType<Map<String, dynamic>>()
          .map(ProjectModel.fromJson)
          .toList(growable: false);
    } on AppFailure {
      rethrow;
    } on Object {
      throw const AppFailure.parse();
    }
  }
}
