import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:portfolio_new/models/portfolio_model.dart';
import 'package:portfolio_new/services/portfolio_cache.dart';
import 'package:portfolio_new/services/portfolio_hardcoded_source.dart';
import 'package:portfolio_new/services/portfolio_remote_data_source.dart';

enum DataSource { remote, cache, hardcoded, safeDefaults }

class PortfolioResult {
  final PortfolioData data;
  final DataSource source;
  final DateTime? timestamp;

  const PortfolioResult({
    required this.data,
    required this.source,
    this.timestamp,
  });
}

class PortfolioRepository {
  final PortfolioRemoteDataSource _remoteDataSource;
  final PortfolioCache _cache;

  PortfolioRepository({
    PortfolioRemoteDataSource? remoteDataSource,
    PortfolioCache? cache,
  }) : _remoteDataSource = remoteDataSource ?? PortfolioRemoteDataSource(),
       _cache = cache ?? PortfolioCache();

  /// Reads initial data immediately from cache if available,
  /// falling back to hardcoded constants, then safe defaults.
  Future<PortfolioResult> getInitialData() async {
    try {
      final cached = await _cache.getCachedData();
      if (cached != null) {
        final ts = await _cache.getCacheTimestamp();
        return PortfolioResult(
          data: cached,
          source: DataSource.cache,
          timestamp: ts,
        );
      }
    } catch (e) {
      debugPrint('⚠️ Cache read error: $e. Falling back to hardcoded.');
    }

    try {
      final hardcoded = PortfolioHardcodedSource.getHardcodedData();
      return PortfolioResult(data: hardcoded, source: DataSource.hardcoded);
    } catch (e) {
      debugPrint(
        '⚠️ Hardcoded constants error: $e. Falling back to safe defaults.',
      );
      return PortfolioResult(
        data: PortfolioData.defaults(),
        source: DataSource.safeDefaults,
      );
    }
  }

  /// Fetches fresh data from remote JSON, saves to cache on success,
  /// and returns the result. Throws on error so the state manager can handle.
  Future<PortfolioResult> fetchRemoteData({String? overrideUrl}) async {
    final rawJson = await _remoteDataSource.fetchRemotePortfolioJson(
      overrideUrl: overrideUrl,
    );

    final decoded = jsonDecode(rawJson);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Remote payload is not a valid JSON map');
    }

    final portfolioData = PortfolioData.fromJson(decoded);

    // Validate minimum required fields
    if (portfolioData.profile.name.trim().isEmpty) {
      throw const FormatException(
        'Remote data is missing required field: profile.name',
      );
    }

    // Cache the validated payload
    await _cache.saveRawJson(rawJson);

    return PortfolioResult(
      data: portfolioData,
      source: DataSource.remote,
      timestamp: DateTime.now(),
    );
  }

  /// Provides the fallback hardcoded constants data directly.
  PortfolioData getHardcodedFallback() {
    return PortfolioHardcodedSource.getHardcodedData();
  }

  /// Provides safe defaults as last resort.
  PortfolioData getSafeDefaults() {
    return PortfolioData.defaults();
  }
}
