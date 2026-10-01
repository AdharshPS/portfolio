import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:portfolio_new/config/portfolio_config.dart';
import 'package:portfolio_new/models/portfolio_model.dart';
import 'package:portfolio_new/utils/platform_utils.dart';

class PortfolioCache {
  final PlatformStorage _storage;

  PortfolioCache({PlatformStorage? storage})
    : _storage = storage ?? getPlatformStorage();

  /// Retrieve cached portfolio data, or null if cache is empty or corrupted.
  Future<PortfolioData?> getCachedData() async {
    try {
      final jsonString = await _storage.read(PortfolioConfig.cacheKey);
      if (jsonString == null || jsonString.trim().isEmpty) {
        return null;
      }

      final decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        await clearCache();
        return null;
      }

      return PortfolioData.fromJson(decoded);
    } catch (e) {
      debugPrint('⚠️ Discarding corrupted cache: $e');
      await clearCache();
      return null;
    }
  }

  /// Retrieve the timestamp of the cached payload.
  Future<DateTime?> getCacheTimestamp() async {
    try {
      final tsStr = await _storage.read(PortfolioConfig.cacheTimestampKey);
      if (tsStr != null) {
        return DateTime.tryParse(tsStr);
      }
    } catch (_) {}
    return null;
  }

  /// Save raw JSON string and current timestamp.
  Future<void> saveRawJson(String rawJson) async {
    try {
      // Validate that it's valid JSON and meets minimum data requirements before saving
      final decoded = jsonDecode(rawJson);
      if (decoded is Map<String, dynamic>) {
        final data = PortfolioData.fromJson(decoded);
        if (data.profile.name.trim().isNotEmpty) {
          await _storage.write(PortfolioConfig.cacheKey, rawJson);
          await _storage.write(
            PortfolioConfig.cacheTimestampKey,
            DateTime.now().toIso8601String(),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ Refusing to cache invalid response: $e');
    }
  }

  /// Discard cached data.
  Future<void> clearCache() async {
    try {
      await _storage.delete(PortfolioConfig.cacheKey);
      await _storage.delete(PortfolioConfig.cacheTimestampKey);
    } catch (_) {}
  }
}
