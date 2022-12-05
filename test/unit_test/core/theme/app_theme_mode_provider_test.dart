// ignore_for_file: avoid-late-keyword
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_riverpod_with_mocktail/core/local_storage/secure_storage/local_storage.dart';
import 'package:test_riverpod_with_mocktail/core/local_storage/secure_storage/local_storage_keys.dart';
import 'package:test_riverpod_with_mocktail/core/local_storage/secure_storage/providers/local_storage_provider.dart';
import 'package:test_riverpod_with_mocktail/core/theme/providers/app_theme_mode_provider.dart';

import '../../helper.dart';

class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  late LocalStorage storage;

  late ProviderContainer providerContainer;

  setUp(() {
    storage = MockLocalStorage();

    providerContainer = makeProviderContainer(
      overrides: [
        localStorageProvider.overrideWithValue(storage),
      ],
    );
  });

  group('appThemeModeProvider - ', () {
    test(
      'Get ThemeMode(light) of APP',
      () async {
        /// arrange
        when(() => storage.get(LocalStorageKeys.isLightTheme)).thenAnswer((_) => Future.value('true'));

        /// run
        final listener = ProviderListener<AsyncValue<ThemeMode>>();
        providerContainer.listen(
          appThemeModeProvider,
          listener,
          fireImmediately: true,
        );

        // Check state before completing future
        // 1. by verify
        verify(() => listener(null, const AsyncLoading<ThemeMode>()));
        // 2. by expect
        expect(providerContainer.read(appThemeModeProvider), const AsyncLoading<ThemeMode>());

        // Finish the future operation
        await providerContainer.read(appThemeModeProvider.future);

        // Check state when future completed.
        // 1.
        verify(
          () => listener(
            const AsyncLoading<ThemeMode>(),
            const AsyncData<ThemeMode>(ThemeMode.light),
          ),
        );
        // 2.
        expect(
          providerContainer.read(appThemeModeProvider),
          const AsyncData<ThemeMode>(ThemeMode.light),
        );

        // No new status
        verifyNoMoreInteractions(listener);

        // Only be called one time
        verify(() => storage.get(any())).called(1);
      },
    );
    test(
      'Get ThemeMode(dark) of APP',
      () async {
        /// arrange
        when(() => storage.get(LocalStorageKeys.isLightTheme)).thenAnswer((_) => Future.value('false'));

        /// run
        final listener = ProviderListener<AsyncValue<ThemeMode>>();
        providerContainer.listen(
          appThemeModeProvider,
          listener,
          fireImmediately: true,
        );

        // Check state before complete future
        // 1. by verify
        verify(() => listener(null, const AsyncLoading<ThemeMode>()));
        // 2. by expect
        expect(providerContainer.read(appThemeModeProvider), const AsyncLoading<ThemeMode>());

        // Finish the future operation
        await providerContainer.read(appThemeModeProvider.future);

        // Check state when future completed.
        // 1.
        verify(() => listener(const AsyncLoading<ThemeMode>(), const AsyncData<ThemeMode>(ThemeMode.dark)));
        // 2.
        expect(providerContainer.read(appThemeModeProvider), const AsyncData<ThemeMode>(ThemeMode.dark));

        // No new status
        verifyNoMoreInteractions(listener);

        // Only be called one time
        verify(() => storage.get(any())).called(1);
      },
    );
  });
}
