import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../local_storage/secure_storage/local_storage_keys.dart';
import '../../local_storage/secure_storage/providers/local_storage_provider.dart';
import 'app_theme_mode_provider.dart';

final appThemeModeNotifierProvider = AsyncNotifierProvider.autoDispose<AppThemeModeNotifier, ThemeMode>(
  AppThemeModeNotifier.new,
);

class AppThemeModeNotifier extends AutoDisposeAsyncNotifier<ThemeMode> {
  final StreamController<ThemeMode> streamController = StreamController();
  Stream<ThemeMode> get currentModeStream => streamController.stream;

  @override
  Future<ThemeMode> build() async {
    final bool isLightTheme =
        (await ref.read(localStorageProvider).get(LocalStorageKeys.isLightTheme)) == 'true' || false;

    ref.onDispose(streamController.close);

    final currentThemeMode = isLightTheme ? ThemeMode.light : ThemeMode.dark;

    if (!streamController.isClosed) {
      streamController.sink.add(currentThemeMode);
    }

    return currentThemeMode;
  }

  Future<void> toggleMode() async {
    state = const AsyncLoading();

    final bool isLightTheme =
        (await ref.read(localStorageProvider).get(LocalStorageKeys.isLightTheme)) == 'true' || false;

    ThemeMode currentThemeMode = isLightTheme ? ThemeMode.light : ThemeMode.dark;
    if (currentThemeMode == ThemeMode.light) {
      currentThemeMode = ThemeMode.dark;
    } else {
      currentThemeMode = ThemeMode.light;
    }

    await ref.read(localStorageProvider).set(LocalStorageKeys.isLightTheme, currentThemeMode == ThemeMode.light);
    final _ = ref.refresh(appThemeModeProvider);

    streamController.sink.add(currentThemeMode);
    state = await AsyncValue.guard(() async => currentThemeMode);

    ref.invalidateSelf();
  }
}
