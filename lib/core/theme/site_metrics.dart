import 'package:flutter/material.dart';

abstract final class SiteMetrics {
  static const double maxWidth = 1440;
  static const double gutter = 80;
  static const double gutterCompact = 24;
  static const double compactBreakpoint = 900;
  static const double statusBreakpoint = 1200;

  static const double headerHeight = 96;
  static const double footerHeight = 104;
  static const double headerLogo = 44;
  static const double headerGap = 36;
  static const double headerPill = 44;

  static const double sectionGap = 160;
  static const double sectionPadding = 120;
  static const double contactPadding = 140;
  static const double heroTop = 56;
  static const double columnGap = 80;
  static const double stackGap = 96;

  static const double heroPhotoWidth = 400;
  static const double heroPhotoHeight = 500;
  static const double heroCircle = 150;
  static const double heroCircleOffset = 30;
  static const double heroBioWidth = 600;
  static const double heroButton = 56;

  static const double featuredCard = 460;
  static const double featuredPadding = 64;
  static const double featuredTextWidth = 540;
  static const double featuredButton = 52;

  static const double phoneWidth = 210;
  static const double phoneHeight = 430;
  static const double phoneFrame = 9;
  static const double featuredPhoneMin = 940;
  static const double phoneTop = 70;
  static const double phoneRight = 120;
  static const double phoneAngle = -8;

  static const double projectThumb = 88;
  static const double projectArrow = 52;
  static const double projectGap = 48;

  static const double stackColumn = 440;
  static const double stackCardPadding = 32;
  static const double stackGroupLabel = 160;
  static const double chipHeight = 36;

  static const double timelineDotCurrent = 18;
  static const double timelineDotHalo = 7;
  static const double timelineDot = 16;
  static const double timelineLineTop = 11;
  static const double timelineArrow = 22;
  static const double timelineGap = 56;
  static const double timelineTextWidth = 360;
  static const double educationTop = 80;

  static const double contactColumn = 580;
  static const double sectionPlaceholder = 320;

  static const BorderRadius featuredRadius = BorderRadius.all(
    Radius.circular(40),
  );
  static const BorderRadius phoneRadius = BorderRadius.all(Radius.circular(40));
  static const BorderRadius phoneScreenRadius = BorderRadius.all(
    Radius.circular(32),
  );
  static const BorderRadius thumbRadius = BorderRadius.all(Radius.circular(26));
  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(32));
  static const BorderRadius educationRadius = BorderRadius.all(
    Radius.circular(28),
  );
  static const BorderRadius heroPhotoRadius = BorderRadius.only(
    topLeft: Radius.circular(200),
    topRight: Radius.circular(200),
    bottomLeft: Radius.circular(28),
    bottomRight: Radius.circular(28),
  );

  static bool isCompact(double width) => width < compactBreakpoint;

  static bool showsStatus(double width) => width >= statusBreakpoint;
}
