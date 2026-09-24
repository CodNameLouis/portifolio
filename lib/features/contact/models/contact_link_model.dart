import 'package:equatable/equatable.dart';
import 'package:portfolio_luan/features/contact/models/contact_link_type.dart';

class ContactLinkModel extends Equatable {
  const ContactLinkModel({
    required this.type,
    required this.label,
    required this.value,
    required this.url,
  });

  factory ContactLinkModel.fromJson(Map<String, dynamic> json) {
    final type = ContactLinkType.fromKey(json['type'] as String?);
    final label = json['label'] as String?;

    return ContactLinkModel(
      type: type,
      label: label?.isNotEmpty ?? false ? label! : type?.label ?? '',
      value: json['value'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  final ContactLinkType? type;
  final String label;
  final String value;
  final String url;

  @override
  List<Object?> get props => [type, label, value, url];
}
