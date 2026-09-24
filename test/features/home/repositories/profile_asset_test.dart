import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_luan/core/services/json_asset_loader.dart';
import 'package:portfolio_luan/features/home/repositories/local_profile_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('o profile.json do app é válido e tem os 3 stats do design', () async {
    final repository = LocalProfileRepository(
      loader: JsonAssetLoader(bundle: rootBundle),
    );

    final profile = await repository.fetch();

    expect(profile.firstName, isNotEmpty);
    expect(profile.lastName, isNotEmpty);
    expect(profile.greeting, isNotEmpty);
    expect(profile.bio, isNotEmpty);
    expect(profile.availabilityLabel, isNotEmpty);
    expect(profile.photo, isNotEmpty);
    expect(profile.stats, hasLength(3));
    expect(profile.stats.first.emphasis, isTrue);
  });
}
