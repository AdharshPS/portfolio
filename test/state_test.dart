import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_new/config/portfolio_config.dart';
import 'package:portfolio_new/services/portfolio_cache.dart';
import 'package:portfolio_new/services/portfolio_notifier.dart';
import 'package:portfolio_new/services/portfolio_remote_data_source.dart';
import 'package:portfolio_new/services/portfolio_repository.dart';
import 'package:portfolio_new/services/portfolio_state.dart';
import 'package:portfolio_new/utils/platform_utils_interface.dart';

class StateFakePlatformStorage implements PlatformStorage {
  final Map<String, String> data = {};

  @override
  Future<String?> read(String key) async => data[key];

  @override
  Future<void> write(String key, String value) async => data[key] = value;

  @override
  Future<void> delete(String key) async => data.remove(key);
}

class StateFakeRemoteDataSource extends PortfolioRemoteDataSource {
  String? responseData;
  Exception? throwException;

  StateFakeRemoteDataSource({this.responseData, this.throwException});

  @override
  Future<String> fetchRemotePortfolioJson({String? overrideUrl}) async {
    if (throwException != null) throw throwException!;
    return responseData!;
  }
}

void main() {
  const remotePayload = '''{
    "profile": {
      "name": "Adharsh P S (Remote)",
      "role": "Senior Flutter Developer"
    },
    "projects": []
  }''';

  const cachedPayload = '''{
    "profile": {
      "name": "Adharsh P S (Cached)",
      "role": "Cached Role"
    },
    "projects": []
  }''';

  group('PortfolioState and Notifier Tests', () {
    late StateFakePlatformStorage storage;
    late PortfolioCache cache;
    late StateFakeRemoteDataSource remote;

    setUp(() {
      storage = StateFakePlatformStorage();
      cache = PortfolioCache(storage: storage);
      remote = StateFakeRemoteDataSource(responseData: remotePayload);
    });

    test('Initial loading provides immediate data without blocking', () {
      final repo = PortfolioRepository(remoteDataSource: remote, cache: cache);
      final notifier = PortfolioNotifier(repository: repo);

      // Immediately after construction, state has fallback data and initial status
      expect(notifier.state.status, equals(PortfolioStatus.initial));
      expect(notifier.state.data.profile.name, isNotEmpty);
    });

    test(
      'initialize loads cache then transitions to loaded after remote succeeds',
      () async {
        await storage.write(PortfolioConfig.cacheKey, cachedPayload);
        await storage.write(
          PortfolioConfig.cacheTimestampKey,
          DateTime.now().toIso8601String(),
        );

        final repo = PortfolioRepository(
          remoteDataSource: remote,
          cache: cache,
        );
        final notifier = PortfolioNotifier(repository: repo);

        await notifier.initialize();

        expect(notifier.state.status, equals(PortfolioStatus.loaded));
        expect(notifier.state.dataSource, equals(DataSource.remote));
        expect(
          notifier.state.data.profile.name,
          equals('Adharsh P S (Remote)'),
        );
      },
    );

    test(
      'initialize with offline remote keeps cached data as offlineCached',
      () async {
        await storage.write(PortfolioConfig.cacheKey, cachedPayload);
        await storage.write(
          PortfolioConfig.cacheTimestampKey,
          DateTime.now().toIso8601String(),
        );

        remote.throwException = DioException(
          requestOptions: RequestOptions(path: ''),
          message: 'No internet connection',
        );

        final repo = PortfolioRepository(
          remoteDataSource: remote,
          cache: cache,
        );
        final notifier = PortfolioNotifier(repository: repo);

        await notifier.initialize();

        expect(notifier.state.status, equals(PortfolioStatus.offlineCached));
        expect(notifier.state.dataSource, equals(DataSource.cache));
        expect(
          notifier.state.data.profile.name,
          equals('Adharsh P S (Cached)'),
        );
      },
    );

    test('refresh success updates UI and data to remote', () async {
      final repo = PortfolioRepository(remoteDataSource: remote, cache: cache);
      final notifier = PortfolioNotifier(repository: repo);
      await notifier.initialize();

      // Change remote payload
      remote.responseData = '''{
        "profile": {
          "name": "Adharsh P S (Refreshed)",
          "role": "Lead Flutter Developer"
        },
        "projects": []
      }''';

      final success = await notifier.refresh();
      expect(success, isTrue);
      expect(notifier.state.status, equals(PortfolioStatus.loaded));
      expect(
        notifier.state.data.profile.name,
        equals('Adharsh P S (Refreshed)'),
      );
      expect(notifier.state.dataSource, equals(DataSource.remote));
    });

    test(
      'refresh failure preserves existing data and marks state as error',
      () async {
        final repo = PortfolioRepository(
          remoteDataSource: remote,
          cache: cache,
        );
        final notifier = PortfolioNotifier(repository: repo);
        await notifier.initialize();

        // Configure failure
        remote.throwException = DioException(
          requestOptions: RequestOptions(path: ''),
          message: 'Server 500 error',
        );

        final success = await notifier.refresh();
        expect(success, isFalse);
        expect(notifier.state.status, equals(PortfolioStatus.error));
        expect(notifier.state.errorMessage, contains('Server 500 error'));
        // Data is preserved and not blank!
        expect(
          notifier.state.data.profile.name,
          equals('Adharsh P S (Remote)'),
        );
      },
    );
  });
}
