import 'package:flutter/material.dart';

class AppColors {
  static final Color defaultColor = getColorFromHex('#008cbf');
  static final Color defaultColorDark = getColorFromHex('#0376a0');
  static final Color badgeColor = getColorFromHex('#db544e');

  //Button colors
  static final Color actionButtonColor = defaultColor;
  static final Color criticalButtonColor = getColorFromHex('#db544e');

  //Text colors
  static final Color labelColor = getColorFromHex('#777777');
  static final Color placeholderColor = getColorFromHex('#AAAAAA');

  //Chart colors
  static final Color chartLineColor = getColorFromHex('#5dd2a9');
  static final Color chartGridLineColor = getColorFromHex('#f0f0f0');

  //Success and failure colors
  static const Color successColor = Color.fromRGBO(43, 186, 104, 1.0);
  static const Color failureColor = Color.fromRGBO(212, 28, 28, 1.0);

  //Contrast background color for views like search bar, chips, etc
  static const Color primaryContrastColor = Color.fromRGBO(240, 240, 240, 1.0);

  //Performance colors
  static final Color goodPerformanceColor = getColorFromHex('#2bba68');
  static final Color averagePerformanceColor = getColorFromHex('#f0ad4e');
  static final Color badPerformanceColor = getColorFromHex('#db544e');

  //Leave status colors
  static final Color pendingApprovalColor = getColorFromHex('#f0ad4e');
  static final Color approvedColor = getColorFromHex('#2bba68');
  static final Color rejectedColor = getColorFromHex('#db544e');
  static final Color cancelledColor = getColorFromHex('#db544e');

  //MARK: Util function to convert hex string to color
  static Color getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }

    return Color(int.parse(hexColor, radix: 16));
  }
}
