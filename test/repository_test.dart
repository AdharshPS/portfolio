import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_new/config/portfolio_config.dart';
import 'package:portfolio_new/services/portfolio_cache.dart';
import 'package:portfolio_new/services/portfolio_remote_data_source.dart';
import 'package:portfolio_new/services/portfolio_repository.dart';
import 'package:portfolio_new/utils/platform_utils_interface.dart';

class FakePlatformStorage implements PlatformStorage {
  final Map<String, String> data = {};

  @override
  Future<String?> read(String key) async => data[key];

  @override
  Future<void> write(String key, String value) async => data[key] = value;

  @override
  Future<void> delete(String key) async => data.remove(key);
}

class FakeRemoteDataSource extends PortfolioRemoteDataSource {
  final String? responseData;
  final Exception? throwException;

  FakeRemoteDataSource({this.responseData, this.throwException});

  @override
  Future<String> fetchRemotePortfolioJson({String? overrideUrl}) async {
    if (throwException != null) throw throwException!;
    return responseData!;
  }
}

void main() {
  const validJson = '''{
    "profile": {
      "name": "Adharsh P S",
      "role": "Flutter Mobile Developer"
    },
    "projects": []
  }''';

  group('PortfolioRepository Tests', () {
    late FakePlatformStorage storage;
    late PortfolioCache cache;

    setUp(() {
      storage = FakePlatformStorage();
      cache = PortfolioCache(storage: storage);
    });

    test(
      'getInitialData falls back to hardcoded constants when cache is empty',
      () async {
        final repo = PortfolioRepository(
          remoteDataSource: FakeRemoteDataSource(responseData: validJson),
          cache: cache,
        );

        final result = await repo.getInitialData();
        expect(result.source, equals(DataSource.hardcoded));
        expect(result.data.profile.name, equals('Adharsh P S'));
        expect(result.data.projects.isNotEmpty, isTrue);
      },
    );

    test(
      'getInitialData returns cache data when cache contains valid payload',
      () async {
        await storage.write(PortfolioConfig.cacheKey, validJson);
        await storage.write(
          PortfolioConfig.cacheTimestampKey,
          DateTime.now().toIso8601String(),
        );

        final repo = PortfolioRepository(
          remoteDataSource: FakeRemoteDataSource(responseData: validJson),
          cache: cache,
        );

        final result = await repo.getInitialData();
        expect(result.source, equals(DataSource.cache));
        expect(result.data.profile.name, equals('Adharsh P S'));
      },
    );

    test(
      'getInitialData discards corrupted cache and falls back to hardcoded constants',
      () async {
        await storage.write(
          PortfolioConfig.cacheKey,
          '{bad json corrupted content',
        );

        final repo = PortfolioRepository(
          remoteDataSource: FakeRemoteDataSource(responseData: validJson),
          cache: cache,
        );

        final result = await repo.getInitialData();
        expect(result.source, equals(DataSource.hardcoded));
        // Corrupted cache must be deleted
        expect(await storage.read(PortfolioConfig.cacheKey), isNull);
      },
    );

    test(
      'fetchRemoteData success updates cache and returns remote result',
      () async {
        final repo = PortfolioRepository(
          remoteDataSource: FakeRemoteDataSource(responseData: validJson),
          cache: cache,
        );

        final result = await repo.fetchRemoteData();
        expect(result.source, equals(DataSource.remote));
        expect(result.data.profile.name, equals('Adharsh P S'));

        // Verified cached
        final cachedString = await storage.read(PortfolioConfig.cacheKey);
        expect(cachedString, equals(validJson));
        final ts = await storage.read(PortfolioConfig.cacheTimestampKey);
        expect(ts, isNotNull);
      },
    );

    test(
      'fetchRemoteData propagates HTTP errors and does not corrupt cache',
      () async {
        await storage.write(PortfolioConfig.cacheKey, validJson);

        final repo = PortfolioRepository(
          remoteDataSource: FakeRemoteDataSource(
            throwException: DioException(
              requestOptions: RequestOptions(path: ''),
              type: DioExceptionType.badResponse,
              message: '404 Not Found',
            ),
          ),
          cache: cache,
        );

        expect(() => repo.fetchRemoteData(), throwsA(isA<DioException>()));
        // Existing cache remains intact
        expect(await storage.read(PortfolioConfig.cacheKey), equals(validJson));
      },
    );

    test('fetchRemoteData propagates timeout errors', () async {
      final repo = PortfolioRepository(
        remoteDataSource: FakeRemoteDataSource(
          throwException: DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionTimeout,
            message: 'Connection timed out',
          ),
        ),
        cache: cache,
      );

      expect(() => repo.fetchRemoteData(), throwsA(isA<DioException>()));
    });

    test(
      'fetchRemoteData rejects invalid JSON and missing required fields',
      () async {
        final repoInvalidJson = PortfolioRepository(
          remoteDataSource: FakeRemoteDataSource(
            responseData: 'not a json string',
          ),
          cache: cache,
        );
        expect(() => repoInvalidJson.fetchRemoteData(), throwsFormatException);

        final repoMissingName = PortfolioRepository(
          remoteDataSource: FakeRemoteDataSource(
            responseData: '{"profile": {"name": ""}}',
          ),
          cache: cache,
        );
        expect(() => repoMissingName.fetchRemoteData(), throwsFormatException);
      },
    );
  });
}
