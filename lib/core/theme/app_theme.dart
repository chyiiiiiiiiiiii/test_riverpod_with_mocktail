// ignore_for_file: no-equal-arguments

import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getThemeData({required bool isLightTheme}) => ThemeData(
        colorScheme: isLightTheme ? const ColorScheme.light() : const ColorScheme.dark(),
        useMaterial3: true,
        visualDensity: VisualDensity.standard,
      );
}
