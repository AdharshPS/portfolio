import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_new/widgets/portfolio_image.dart';

void main() {
  testWidgets('PortfolioImage renders Image.asset for local assets', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PortfolioImage(
            imagePath: 'assets/images/me.png',
            fallbackAsset: 'assets/images/fallback.png',
            width: 100,
            height: 100,
          ),
        ),
      ),
    );

    expect(find.byType(Image), findsOneWidget);
    final imageWidget = tester.widget<Image>(find.byType(Image));
    expect(imageWidget.image, isA<AssetImage>());
    final assetImage = imageWidget.image as AssetImage;
    expect(assetImage.assetName, equals('assets/images/me.png'));
  });

  testWidgets(
    'PortfolioImage renders CachedNetworkImage for http/https URLs with cacheKey',
    (tester) async {
      const testUrl = 'https://example.com/avatar.png?v=2';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PortfolioImage(
              imagePath: testUrl,
              fallbackAsset: 'assets/images/me.png',
              width: 200,
              height: 200,
            ),
          ),
        ),
      );

      expect(find.byType(CachedNetworkImage), findsOneWidget);
      final cachedImage = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );
      expect(cachedImage.imageUrl, equals(testUrl));
      expect(cachedImage.cacheKey, equals(testUrl));
      expect(cachedImage.width, equals(200));
      expect(cachedImage.height, equals(200));
      expect(cachedImage.memCacheWidth, equals(400));
      expect(cachedImage.memCacheHeight, equals(400));
    },
  );

  testWidgets(
    'PortfolioImage handles empty image path with fallbackAsset gracefully',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PortfolioImage(
              imagePath: '',
              fallbackAsset: 'assets/images/me.png',
              width: 150,
              height: 150,
            ),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.image, isA<AssetImage>());
      final assetImage = imageWidget.image as AssetImage;
      expect(assetImage.assetName, equals('assets/images/me.png'));
    },
  );

  testWidgets(
    'PortfolioImage falls back to neutral icon box when fallbackAsset is empty',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PortfolioImage(
              imagePath: '',
              fallbackAsset: '',
              width: 80,
              height: 80,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    },
  );

  testWidgets('PortfolioImage wraps with AspectRatio when specified', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PortfolioImage(
            imagePath: 'assets/images/me.png',
            fallbackAsset: '',
            aspectRatio: 16 / 9,
          ),
        ),
      ),
    );

    expect(find.byType(AspectRatio), findsOneWidget);
    final aspectRatioWidget = tester.widget<AspectRatio>(
      find.byType(AspectRatio),
    );
    expect(aspectRatioWidget.aspectRatio, closeTo(16 / 9, 0.001));
  });
}
