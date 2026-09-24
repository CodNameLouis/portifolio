import 'package:portfolio_luan/core/constants/app_assets.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/core/services/json_asset_loader.dart';
import 'package:portfolio_luan/features/stack/models/stack_model.dart';
import 'package:portfolio_luan/features/stack/repositories/stack_repository.dart';

class LocalStackRepository implements StackRepository {
  const LocalStackRepository({required this.loader});

  final JsonAssetLoader loader;

  @override
  Future<StackModel> fetch() async {
    final json = await loader.load(AppAssets.stackJson);

    try {
      return StackModel.fromJson(json);
    } on AppFailure {
      rethrow;
    } on Object {
      throw const AppFailure.parse();
    }
  }
}
