import 'package:portfolio_luan/core/constants/app_strings.dart';

enum ContactLinkType {
  email(AppStrings.contactEmailLabel, 'email'),
  whatsapp(AppStrings.contactWhatsappLabel, 'whatsapp'),
  linkedin(AppStrings.contactLinkedinLabel, 'linkedin'),
  github(AppStrings.contactGithubLabel, 'github');

  const ContactLinkType(this.label, this.key);

  final String label;
  final String key;

  static ContactLinkType? fromKey(String? key) {
    for (final type in values) {
      if (type.key == key) {
        return type;
      }
    }

    return null;
  }
}
