import 'package:flutter/material.dart';

abstract final class AppRadius {
  static const double featured = 28;
  static const double stackHighlight = 24;
  static const double education = 22;
  static const double thumbnail = 18;
  static const double phoneOuter = 30;
  static const double phoneScreen = 24;
  static const double photoTop = 79;
  static const double photoBottom = 20;

  static const BorderRadius featuredAll = BorderRadius.all(
    Radius.circular(featured),
  );
  static const BorderRadius stackHighlightAll = BorderRadius.all(
    Radius.circular(stackHighlight),
  );
  static const BorderRadius educationAll = BorderRadius.all(
    Radius.circular(education),
  );
  static const BorderRadius thumbnailAll = BorderRadius.all(
    Radius.circular(thumbnail),
  );
  static const BorderRadius phoneOuterAll = BorderRadius.all(
    Radius.circular(phoneOuter),
  );
  static const BorderRadius phoneScreenAll = BorderRadius.all(
    Radius.circular(phoneScreen),
  );
  static const BorderRadius photo = BorderRadius.only(
    topLeft: Radius.circular(photoTop),
    topRight: Radius.circular(photoTop),
    bottomLeft: Radius.circular(photoBottom),
    bottomRight: Radius.circular(photoBottom),
  );
}
