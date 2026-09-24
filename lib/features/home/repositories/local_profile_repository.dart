import 'package:portfolio_luan/core/constants/app_assets.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/core/services/json_asset_loader.dart';
import 'package:portfolio_luan/features/home/models/profile_model.dart';
import 'package:portfolio_luan/features/home/repositories/profile_repository.dart';

class LocalProfileRepository implements ProfileRepository {
  const LocalProfileRepository({required this.loader});

  final JsonAssetLoader loader;

  @override
  Future<ProfileModel> fetch() async {
    final json = await loader.load(AppAssets.profileJson);

    try {
      return ProfileModel.fromJson(json);
    } on AppFailure {
      rethrow;
    } on Object {
      throw const AppFailure.parse();
    }
  }
}
