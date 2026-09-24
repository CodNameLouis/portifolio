import 'package:portfolio_luan/features/stack/models/stack_model.dart';

abstract interface class StackRepository {
  Future<StackModel> fetch();
}
