import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_new/widgets/portfolio_image.dart';

AssetImage _unwrapAssetImage(Image imageWidget) {
  var provider = imageWidget.image;
  if (provider is ResizeImage) {
    provider = provider.imageProvider;
  }
  expect(provider, isA<AssetImage>());
  return provider as AssetImage;
}

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
    final assetImage = _unwrapAssetImage(imageWidget);
    expect(assetImage.assetName, equals('assets/images/me.png'));
  });

  testWidgets(
    'PortfolioImage resolves remote image URLs to local assets without network calls',
    (tester) async {
      const remoteMeUrl =
          'https://github.com/AdharshPS/portfolio/releases/download/assets/me.webp';
      const remoteNoteFlowUrl =
          'https://github.com/AdharshPS/portfolio/releases/download/assets/noteflow.png';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                PortfolioImage(
                  imagePath: remoteMeUrl,
                  fallbackAsset: '',
                  width: 200,
                  height: 200,
                ),
                PortfolioImage(
                  imagePath: remoteNoteFlowUrl,
                  fallbackAsset: '',
                  width: 200,
                  height: 200,
                ),
              ],
            ),
          ),
        ),
      );

      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images.length, equals(2));

      final assetImage1 = _unwrapAssetImage(images[0]);
      expect(assetImage1.assetName, equals('assets/images/me.png'));

      final assetImage2 = _unwrapAssetImage(images[1]);
      expect(
        assetImage2.assetName,
        equals('assets/images/projects/noteflow.png'),
      );
    },
  );

  testWidgets(
    'PortfolioImage handles unknown http/https URLs by falling back without network calls',
    (tester) async {
      const unknownUrl = 'https://unknown-domain.com/random-pic.jpg';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PortfolioImage(
              imagePath: unknownUrl,
              fallbackAsset: 'assets/images/me.png',
              width: 150,
              height: 150,
            ),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
      final imageWidget = tester.widget<Image>(find.byType(Image));
      final assetImage = _unwrapAssetImage(imageWidget);
      expect(assetImage.assetName, equals('assets/images/me.png'));
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
      final assetImage = _unwrapAssetImage(imageWidget);
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
