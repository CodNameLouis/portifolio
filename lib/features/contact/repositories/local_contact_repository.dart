import 'package:portfolio_luan/core/constants/app_assets.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';
import 'package:portfolio_luan/core/services/json_asset_loader.dart';
import 'package:portfolio_luan/features/contact/models/contact_model.dart';
import 'package:portfolio_luan/features/contact/repositories/contact_repository.dart';

class LocalContactRepository implements ContactRepository {
  const LocalContactRepository({required this.loader});

  final JsonAssetLoader loader;

  @override
  Future<ContactModel> fetch() async {
    final json = await loader.load(AppAssets.contactJson);

    try {
      return ContactModel.fromJson(json);
    } on AppFailure {
      rethrow;
    } on Object {
      throw const AppFailure.parse();
    }
  }
}
