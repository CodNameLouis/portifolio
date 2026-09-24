import 'package:portfolio_luan/features/trajectory/models/trajectory_model.dart';

abstract interface class TrajectoryRepository {
  Future<TrajectoryModel> fetch();
}
