import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_new/main.dart';
import 'package:portfolio_new/services/portfolio_cache.dart';
import 'package:portfolio_new/services/portfolio_notifier.dart';
import 'package:portfolio_new/services/portfolio_remote_data_source.dart';
import 'package:portfolio_new/services/portfolio_repository.dart';
import 'package:portfolio_new/utils/platform_utils_interface.dart';

class WidgetTestPlatformStorage implements PlatformStorage {
  final Map<String, String> data = {};

  @override
  Future<String?> read(String key) async => data[key];

  @override
  Future<void> write(String key, String value) async => data[key] = value;

  @override
  Future<void> delete(String key) async => data.remove(key);
}

class TestRemoteDataSource extends PortfolioRemoteDataSource {
  @override
  Future<String> fetchRemotePortfolioJson({String? overrideUrl}) async {
    return '{"profile": {"name": "Adharsh P S"}}';
  }
}

void main() {
  testWidgets('PortfolioApp loads and displays portfolio content', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1440, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final storage = WidgetTestPlatformStorage();
    final cache = PortfolioCache(storage: storage);
    final repo = PortfolioRepository(
      remoteDataSource: TestRemoteDataSource(),
      cache: cache,
    );
    final notifier = PortfolioNotifier(repository: repo);
    await notifier.initialize();

    await tester.pumpWidget(PortfolioApp(notifier: notifier));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('// hello, world'), findsOneWidget);
    expect(find.text('About me'), findsWidgets);
    expect(find.text('Skills'), findsWidgets);
    expect(find.text('Projects'), findsWidgets);

    final refreshIndicatorFinder = find.byType(RefreshIndicator);
    expect(refreshIndicatorFinder, findsOneWidget);
    final refreshIndicator = tester.widget<RefreshIndicator>(refreshIndicatorFinder);
    expect(refreshIndicator.edgeOffset, 68.0);
  });
}
