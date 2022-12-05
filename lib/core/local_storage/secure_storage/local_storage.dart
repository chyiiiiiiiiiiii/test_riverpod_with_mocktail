// ignore_for_file: avoid-dynamic

abstract class LocalStorage {
  /// Initializes service
  Future<void> init();

  /// Checks if an item exists in storage by a key
  Future<bool> has(String key);

  /// Retrieves item from storage by a key
  Future<String?> get(String key);

  /// Sets an item data in storage by a key
  Future<void> set(String key, dynamic data);

  /// Clears storage
  Future<void> clear();

  /// Removes item from storage by a key
  Future<void> remove(String key);

  /// Terminates service
  Future<void> close();
}
