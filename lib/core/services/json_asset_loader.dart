import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:portfolio_luan/core/errors/app_failure.dart';

class JsonAssetLoader {
  const JsonAssetLoader({required this.bundle});

  final AssetBundle bundle;

  Future<Map<String, dynamic>> load(String path) async {
    final String raw;
    try {
      raw = await bundle.loadString(path);
    } on Object {
      throw const AppFailure.load();
    }

    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } on FormatException {
      throw const AppFailure.parse();
    }

    if (decoded is! Map<String, dynamic>) {
      throw const AppFailure.parse();
    }

    return decoded;
  }
}
