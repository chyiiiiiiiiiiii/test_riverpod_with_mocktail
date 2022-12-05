import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/local_storage/secure_storage/local_storage.dart';
import 'core/local_storage/secure_storage/providers/local_storage_provider.dart';
import 'initialization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final LocalStorage storage = await initLocalStorage();

  final providerContainer = ProviderContainer(
    overrides: [
      localStorageProvider.overrideWithValue(storage),
    ],
  );

  runApp(
    UncontrolledProviderScope(
      container: providerContainer,
      child: const App(),
    ),
  );
}
