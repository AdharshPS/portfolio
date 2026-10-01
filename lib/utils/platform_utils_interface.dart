// Platform-independent interface for browser/local storage operations

abstract class PlatformStorage {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

void updateBrowserTitle(String title) {
  // Overridden by platform-specific implementations
}
