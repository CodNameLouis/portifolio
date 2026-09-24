import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_luan/core/constants/app_strings.dart';
import 'package:portfolio_luan/features/contact/models/contact_model.dart';
import 'package:portfolio_luan/features/contact/models/contact_link_type.dart';

void main() {
  test('lê título, links e currículo de um JSON completo', () {
    final contact = ContactModel.fromJson(const {
      'title': 'Vamos tirar seu app do papel?',
      'subtitle': 'Disponibilidade imediata · 100% remoto',
      'links': [
        {
          'type': 'email',
          'label': 'E-mail',
          'value': 'luan@afcinfotelecom.net',
          'url': 'mailto:luan@afcinfotelecom.net',
        },
        {
          'type': 'whatsapp',
          'label': 'WhatsApp',
          'value': '+55 83 99366-5855',
          'url': 'https://wa.me/5583993665855',
        },
      ],
      'resumeUrl': 'https://exemplo.com/curriculo.pdf',
    });

    expect(contact.title, 'Vamos tirar seu app do papel?');
    expect(contact.links, hasLength(2));
    expect(contact.links.first.type, ContactLinkType.email);
    expect(contact.links.last.url, 'https://wa.me/5583993665855');
    expect(contact.resumeUrl, 'https://exemplo.com/curriculo.pdf');
  });

  test('cai no label do enum quando o JSON não traz label', () {
    final contact = ContactModel.fromJson(const {
      'links': [
        {'type': 'github', 'value': 'CodNameLouis'},
      ],
    });

    expect(contact.links.single.label, AppStrings.contactGithubLabel);
  });

  test('tipo desconhecido vira null sem derrubar o link', () {
    final contact = ContactModel.fromJson(const {
      'links': [
        {'type': 'telegram', 'label': 'Telegram', 'value': '@luan'},
      ],
    });

    expect(contact.links.single.type, isNull);
    expect(contact.links.single.label, 'Telegram');
  });

  test('vazios quando os campos faltam', () {
    final contact = ContactModel.fromJson(const {});

    expect(contact.title, isEmpty);
    expect(contact.links, isEmpty);
    expect(contact.resumeUrl, isEmpty);
  });
}
