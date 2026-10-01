import 'package:web/web.dart' as web;
import 'platform_utils_interface.dart';

class WebPlatformStorage implements PlatformStorage {
  @override
  Future<String?> read(String key) async {
    try {
      return web.window.localStorage.getItem(key);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> write(String key, String value) async {
    try {
      web.window.localStorage.setItem(key, value);
    } catch (_) {
      // Ignored (e.g. private browsing storage limits)
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      web.window.localStorage.removeItem(key);
    } catch (_) {
      // Ignored
    }
  }
}

PlatformStorage getPlatformStorage() => WebPlatformStorage();

void setPlatformBrowserTitle(String title) {
  try {
    web.document.title = title;
  } catch (_) {}
}
