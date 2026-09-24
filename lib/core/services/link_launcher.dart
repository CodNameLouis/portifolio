import 'package:url_launcher/url_launcher.dart';

abstract interface class UrlOpener {
  Future<bool> open(Uri url);
}

class ExternalUrlOpener implements UrlOpener {
  const ExternalUrlOpener();

  @override
  Future<bool> open(Uri url) =>
      launchUrl(url, mode: LaunchMode.externalApplication);
}

class LinkLauncher {
  const LinkLauncher({this.opener = const ExternalUrlOpener()});

  final UrlOpener opener;

  Future<bool> open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      return false;
    }

    try {
      return await opener.open(uri);
    } on Object {
      return false;
    }
  }
}
