import 'package:portfolio_luan/features/contact/models/contact_model.dart';

abstract interface class ContactRepository {
  Future<ContactModel> fetch();
}
