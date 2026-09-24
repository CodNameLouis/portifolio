import 'package:equatable/equatable.dart';
import 'package:portfolio_luan/features/contact/models/contact_link_model.dart';

class ContactModel extends Equatable {
  const ContactModel({
    required this.title,
    required this.subtitle,
    required this.links,
    required this.resumeUrl,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    final rawLinks = json['links'] as List<dynamic>? ?? const [];

    return ContactModel(
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      links: rawLinks
          .whereType<Map<String, dynamic>>()
          .map(ContactLinkModel.fromJson)
          .toList(growable: false),
      resumeUrl: json['resumeUrl'] as String? ?? '',
    );
  }

  final String title;
  final String subtitle;
  final List<ContactLinkModel> links;
  final String resumeUrl;

  @override
  List<Object?> get props => [title, subtitle, links, resumeUrl];
}
