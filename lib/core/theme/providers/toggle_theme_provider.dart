import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../local_storage/secure_storage/local_storage_keys.dart';
import '../../local_storage/secure_storage/providers/local_storage_provider.dart';
import 'app_theme_mode_provider.dart';

final toggleThemeProvider = Provider<void>((ref) async {
  // ThemeMode themeMode = ref.read(databaseProvider).getAppThemeMode();
  final bool isLightTheme = (await ref
              .read(localStorageProvider)
              .get(LocalStorageKeys.isLightTheme)) ==
          'true' ||
      false;
  ThemeMode themeMode = isLightTheme ? ThemeMode.light : ThemeMode.dark;
  if (themeMode == ThemeMode.light) {
    themeMode = ThemeMode.dark;
  } else {
    themeMode = ThemeMode.light;
  }

  // await ref.read(databaseProvider).updateAppThemeMode(themeMode);
  await ref
      .read(localStorageProvider)
      .set(LocalStorageKeys.isLightTheme, themeMode == ThemeMode.light);

  final _ = ref.refresh(appThemeModeProvider);
  ref.invalidateSelf();
});
