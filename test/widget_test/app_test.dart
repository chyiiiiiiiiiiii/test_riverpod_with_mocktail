// ignore_for_file: avoid-returning-widgets

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_riverpod_with_mocktail/core/local_storage/secure_storage/local_storage.dart';
import 'package:test_riverpod_with_mocktail/core/local_storage/secure_storage/providers/local_storage_provider.dart';
import 'package:test_riverpod_with_mocktail/core/theme/providers/app_theme_mode_provider.dart';
import 'package:test_riverpod_with_mocktail/core/theme/providers/app_theme_provider.dart';
import 'package:test_riverpod_with_mocktail/initialization.dart';
import 'package:test_riverpod_with_mocktail/pages/home_page.dart';

import '../unit_test/helper.dart';

Widget getPumpWidget(
  ProviderContainer providerContainer, {
  Widget? child,
}) {
  final appTheme = providerContainer.read(appThemeProvider);
  final appThemeMode = providerContainer.read(appThemeModeProvider).asData?.value;

  return UncontrolledProviderScope(
    container: providerContainer,
    child: child != null
        ? MaterialApp(home: child)
        : MaterialApp(
            title: 'Example',
            theme: appTheme.getThemeData(isLightTheme: true),
            darkTheme: appTheme.getThemeData(isLightTheme: false),
            themeMode: appThemeMode,
            debugShowCheckedModeBanner: false,
            home: const HomePage(),
          ),
  );
}

void main() {
  testWidgets(
    'initialize packages, services and run App.',
    (WidgetTester tester) async {
      WidgetsFlutterBinding.ensureInitialized();

      final LocalStorage storage = await initLocalStorage();

      final providerContainer = makeProviderContainer(
        overrides: [
          localStorageProvider.overrideWithValue(storage),
        ],
      );

      await tester.pumpWidget(
        getPumpWidget(providerContainer),
      );

      await tester.pumpAndSettle();
    },
  );
}
