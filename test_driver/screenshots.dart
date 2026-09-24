import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  await integrationDriver(
    onScreenshot: (String name, List<int> bytes, [Map<String, Object?>? args]) async {
      final arquivo = File('screenshots/$name.png');
      await arquivo.parent.create(recursive: true);
      await arquivo.writeAsBytes(bytes);
      return true;
    },
  );
}
