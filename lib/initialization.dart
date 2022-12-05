import 'dart:async';

import 'core/local_storage/secure_storage/local_storage.dart';
import 'core/local_storage/secure_storage/secure_local_storage.dart';

Future<LocalStorage> initLocalStorage() async {
  final storage = SecureLocalStorage();
  await storage.init();

  return storage;
}
