import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../local_storage/secure_storage/local_storage_keys.dart';
import '../../local_storage/secure_storage/providers/local_storage_provider.dart';

final appThemeModeProvider = FutureProvider<ThemeMode>((ref) async {
  final bool isLightTheme =
      (await ref.read(localStorageProvider).get(LocalStorageKeys.isLightTheme)) == 'true' || false;

  return isLightTheme ? ThemeMode.light : ThemeMode.dark;
});
