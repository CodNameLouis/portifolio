import 'package:portfolio_luan/core/constants/app_assets.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/core/services/json_asset_loader.dart';
import 'package:portfolio_luan/features/trajectory/models/trajectory_model.dart';
import 'package:portfolio_luan/features/trajectory/repositories/trajectory_repository.dart';

class LocalTrajectoryRepository implements TrajectoryRepository {
  const LocalTrajectoryRepository({required this.loader});

  final JsonAssetLoader loader;

  @override
  Future<TrajectoryModel> fetch() async {
    final json = await loader.load(AppAssets.trajectoryJson);

    try {
      return TrajectoryModel.fromJson(json);
    } on AppFailure {
      rethrow;
    } on Object {
      throw const AppFailure.parse();
    }
  }
}
