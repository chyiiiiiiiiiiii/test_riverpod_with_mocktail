// ignore_for_file: avoid-late-keyword

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_riverpod_with_mocktail/core/local_storage/secure_storage/local_storage.dart';
import 'package:test_riverpod_with_mocktail/core/local_storage/secure_storage/providers/local_storage_provider.dart';

import '../app_test.dart';

class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  late ProviderContainer providerContainer;
  late LocalStorage storage;

  setUp(() async {
    storage = MockLocalStorage();

    providerContainer = ProviderContainer(
      overrides: [
        localStorageProvider.overrideWithValue(storage),
      ],
    );
  });

  group('Home page ->', () {
    testWidgets(
      'check UI is correct.',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          getPumpWidget(providerContainer),
        );

        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        expect(find.byIcon(Icons.light_mode), findsOneWidget);
      },
    );
  });
}
