// ignore_for_file: avoid-dynamic

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'local_storage.dart';

class SecureLocalStorage implements LocalStorage {
  FlutterSecureStorage? storage;

  @override
  Future<void> init() async {
    storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );
  }

  @override
  Future<void> remove(String key) async {
    await storage?.delete(key: key);
  }

  @override
  Future<String?> get(String key) {
    return storage?.read(key: key) ?? Future.value();
  }

  @override
  Future<bool> has(String key) async {
    return (await storage?.containsKey(key: key)) ?? false;
  }

  @override
  Future<void> set(String key, dynamic data) async {
    await storage?.write(
      key: key,
      value: data.toString(),
    );
  }

  @override
  Future<void> clear() async {
    await storage?.deleteAll();
  }

  @override
  // Not exist close operation
  // ignore: no-empty-block
  Future<void> close() async {}
}
