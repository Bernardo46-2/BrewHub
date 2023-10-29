import 'package:flutter/material.dart';

class IconUtility {
  static const Map<String, IconData> iconNameToData = {
    'business': Icons.business,
    'calendar_month': Icons.calendar_month,
    'school': Icons.school,
    'flight': Icons.flight,
    // Add more icons as needed
  };

  static IconData getIconDataFromString(String iconName) {
    return iconNameToData[iconName] ?? Icons.business;
  }

  static String getStringFromIconData(IconData iconData) {
    return iconNameToData.entries
        .firstWhere((entry) => entry.value == iconData, orElse: () => const MapEntry('error', Icons.business))
        .key;
  }
}
