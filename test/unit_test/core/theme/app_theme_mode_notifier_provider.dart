// ignore_for_file: avoid-late-keyword
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_riverpod_with_mocktail/core/local_storage/secure_storage/local_storage.dart';
import 'package:test_riverpod_with_mocktail/core/local_storage/secure_storage/local_storage_keys.dart';
import 'package:test_riverpod_with_mocktail/core/local_storage/secure_storage/providers/local_storage_provider.dart';
import 'package:test_riverpod_with_mocktail/core/theme/providers/app_theme_mode_notifier_provider.dart';

import '../../helper.dart';

class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  late LocalStorage storage;

  late ProviderContainer providerContainer;

  setUp(() {
    /// setup
    storage = MockLocalStorage();

    providerContainer = makeProviderContainer(
      overrides: [
        localStorageProvider.overrideWithValue(storage),
      ],
    );
  });

  group('appThemeModeNotifierProvider & AppThemeModeNotifier -', () {
    test(
      'initialize in build() and get ThemeMode.light',
      () async {
        /// arrange

        when(() => storage.get(LocalStorageKeys.isLightTheme)).thenAnswer((_) async => 'true');

        /// run

        final listener = ProviderListener<AsyncValue<ThemeMode>>();
        // Listen testAppThemeModeProvider to check status later.
        providerContainer.listen(
          appThemeModeNotifierProvider,
          listener,
          fireImmediately: true,
        );

        // In the beginning, always from null data to Loading state.
        verify(() => listener(null, const AsyncLoading()));
        verifyNoMoreInteractions(listener);

        // Complete build() of AsyncNotifier.
        // Need to use expectLater() to check current state.
        await expectLater(await providerContainer.read(appThemeModeNotifierProvider.notifier).future, ThemeMode.light);

        // Try to get local data from local storage in build().
        verify(() => storage.get(LocalStorageKeys.isLightTheme)).called(1);
      },
    );
    test(
      'initialize in build() but throw exception.',
      () async {
        /// arrange

        when(() => storage.get(LocalStorageKeys.isLightTheme)).thenThrow(Exception('Can not get theme!'));

        /// run

        final listener = ProviderListener<AsyncValue<ThemeMode>>();
        // Listen testAppThemeModeProvider to check status later.
        providerContainer.listen(
          appThemeModeNotifierProvider,
          listener,
          fireImmediately: true,
        );

        // In the beginning, always from null data to Loading state.
        verify(() => listener(null, const AsyncLoading()));
        verifyNoMoreInteractions(listener);

        // Try to get local data from local storage in build().
        verify(() => storage.get(LocalStorageKeys.isLightTheme)).called(1);

        // Till the operation is done, the data retrieving will throw Exception.
        // 1. throwsA -> isA
        await expectLater(() async => providerContainer.read(appThemeModeNotifierProvider.notifier).future, throwsA(isA<Exception>()));
        // 2. throwsA -> isInstanceOf
        await expectLater(
          () async => providerContainer.read(appThemeModeNotifierProvider.notifier).future,
          throwsA(
            isInstanceOf<Exception>(),
          ),
        );
      },
    );
    test(
      'call toggleMode() and new state is ThemeMode.dark',
      () async {
        /// arrange

        when(() => storage.get(LocalStorageKeys.isLightTheme)).thenAnswer((_) async => Future.value('true'));
        when(() => storage.set(LocalStorageKeys.isLightTheme, any())).thenAnswer((invocation) => Future.value());

        /// run

        final listener = ProviderListener<AsyncValue<ThemeMode>>();
        providerContainer.listen(
          appThemeModeNotifierProvider,
          listener,
          fireImmediately: true,
        );

        // When listen the provider, it will initialize and run build()
        verify(() => storage.get(LocalStorageKeys.isLightTheme)).called(1);

        await providerContainer.read(appThemeModeNotifierProvider.notifier).toggleMode();

        // All for toggle() process
        verifyInOrder([
          // Beginning set the loading state
          () => listener(null, const AsyncLoading<ThemeMode>()),
          () => listener(const AsyncLoading<ThemeMode>(), const AsyncData<ThemeMode>(ThemeMode.light)),
          () => listener(const AsyncData(ThemeMode.light), const AsyncData(ThemeMode.dark)),
        ]);

        // First, call storage.get() in toggle() beginning
        // Second, call storage.get() in appThemeModeProvider because we refresh it.
        verify(() => storage.get(LocalStorageKeys.isLightTheme)).called(2);
      },
    );
    test(
      'call toggleMode() and check stream data is correct',
      () async {
        /// arrange

        when(() => storage.get(LocalStorageKeys.isLightTheme)).thenAnswer((_) async => Future.value('true'));
        when(() => storage.set(LocalStorageKeys.isLightTheme, any<bool>())).thenAnswer((invocation) => Future.value());

        /// run

        await providerContainer.read(appThemeModeNotifierProvider.notifier).toggleMode();

        // call once in build()
        // call once in toggleMode()
        // call once in appThemeModeProvider
        verify(() => storage.get(LocalStorageKeys.isLightTheme)).called(3);

        expect(
          providerContainer.read(appThemeModeNotifierProvider.notifier).currentModeStream,
          emitsInOrder(
            const [
              ThemeMode.light,
              ThemeMode.dark,
            ],
          ),
        );

        // call once in build()
        verify(() => storage.get(LocalStorageKeys.isLightTheme)).called(1);
      },
    );
    test(
      'call toggleMode() but throw exception.',
      () async {
        /// arrange

        when(() => storage.get(LocalStorageKeys.isLightTheme)).thenThrow(Exception('Can not get theme!'));
        when(() => storage.set(LocalStorageKeys.isLightTheme, any<bool>())).thenAnswer((invocation) => Future.value());

        /// run

        final listener = ProviderListener<AsyncValue<ThemeMode>>();
        providerContainer.listen(
          appThemeModeNotifierProvider,
          listener,
          fireImmediately: true,
        );

        // When listen the provider, it will initialize and run build()
        verify(() => storage.get(LocalStorageKeys.isLightTheme)).called(1);

        await expectLater(() async => providerContainer.read(appThemeModeNotifierProvider.notifier).toggleMode(), throwsA(isA<Exception>()));

        verifyInOrder([
          // Beginning set the loading state
          () => listener(null, const AsyncLoading()),
          // Error will appear when complete
          () => listener(
                const AsyncLoading(),
                any(
                  that: predicate<AsyncValue<void>>(
                    (value) {
                      expect(value.hasError, true);

                      return true;
                    },
                  ),
                ),
              ),
        ]);

        // Call storage.get() again
        verify(() => storage.get(LocalStorageKeys.isLightTheme)).called(1);
      },
    );
  });
}
