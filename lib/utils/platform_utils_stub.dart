import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'platform_utils_interface.dart';

class StubPlatformStorage implements PlatformStorage {
  static final Map<String, String> _memoryCache = {};

  @override
  Future<String?> read(String key) async {
    try {
      if (kIsWeb) return _memoryCache[key];
      final dir = await getApplicationDocumentsDirectory().timeout(
        const Duration(seconds: 1),
      );
      final file = File('${dir.path}/$key.txt');
      if (await file.exists()) {
        return await file.readAsString();
      }
    } catch (_) {
      // Fall back to memory cache if filesystem fails or in test
    }
    return _memoryCache[key];
  }

  @override
  Future<void> write(String key, String value) async {
    _memoryCache[key] = value;
    try {
      if (!kIsWeb) {
        final dir = await getApplicationDocumentsDirectory().timeout(
          const Duration(seconds: 1),
        );
        final file = File('${dir.path}/$key.txt');
        await file.writeAsString(value);
      }
    } catch (_) {
      // Ignored for tests/unsupported environments
    }
  }

  @override
  Future<void> delete(String key) async {
    _memoryCache.remove(key);
    try {
      if (!kIsWeb) {
        final dir = await getApplicationDocumentsDirectory().timeout(
          const Duration(seconds: 1),
        );
        final file = File('${dir.path}/$key.txt');
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (_) {
      // Ignored
    }
  }
}

PlatformStorage getPlatformStorage() => StubPlatformStorage();

void setPlatformBrowserTitle(String title) {
  // No-op for non-web platforms
}
