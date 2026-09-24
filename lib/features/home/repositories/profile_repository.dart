import 'package:portfolio_luan/features/home/models/profile_model.dart';

abstract interface class ProfileRepository {
  Future<ProfileModel> fetch();
}
