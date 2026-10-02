import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_new/models/portfolio_model.dart';
import 'package:portfolio_new/widgets/device_frame.dart';
void main() {
  group('DeviceType Model Parsing Tests', () {
    test('Parses deviceType correctly with case-insensitivity, tag inference, and defaults', () {
      final jsonPhone = {'title': 'Phone App', 'deviceType': 'phone'};
      final pPhone = Project.fromJson(jsonPhone);
      expect(pPhone.deviceType, equals(DeviceType.phone));

      final jsonDesktop = {'title': 'Desktop App', 'deviceType': 'DESKTOP'};
      final pDesktop = Project.fromJson(jsonDesktop);
      expect(pDesktop.deviceType, equals(DeviceType.desktop));

      final jsonWeb = {'title': 'Web App', 'deviceType': 'Web'};
      final pWeb = Project.fromJson(jsonWeb);
      expect(pWeb.deviceType, equals(DeviceType.web));

      // Test tag inference when deviceType is omitted
      final jsonTagDesktop = {
        'title': 'Sync App',
        'tags': ['Flutter', 'Windows Desktop', 'REST API']
      };
      final pTagDesktop = Project.fromJson(jsonTagDesktop);
      expect(pTagDesktop.deviceType, equals(DeviceType.desktop));

      final jsonTagWeb = {
        'title': 'REST Tool',
        'tags': ['Flutter', 'Web', 'Firebase']
      };
      final pTagWeb = Project.fromJson(jsonTagWeb);
      expect(pTagWeb.deviceType, equals(DeviceType.web));

      final jsonUnknown = {'title': 'Unknown', 'deviceType': 'tablet_or_watch'};
      final pUnknown = Project.fromJson(jsonUnknown);
      expect(pUnknown.deviceType, equals(DeviceType.phone));

      final jsonMissing = {'title': 'No Type'};
      final pMissing = Project.fromJson(jsonMissing);
      expect(pMissing.deviceType, equals(DeviceType.phone));

      final jsonNull = {'title': 'Null Type', 'deviceType': null};
      final pNull = Project.fromJson(jsonNull);
      expect(pNull.deviceType, equals(DeviceType.phone));

      // Serialization
      expect(pDesktop.toJson()['deviceType'], equals('desktop'));
      expect(pWeb.toJson()['deviceType'], equals('web'));
      expect(pPhone.toJson()['deviceType'], equals('phone'));
    });
  });

  group('DeviceFrame Widget Tests', () {
    testWidgets('DeviceFrame renders phone variant within 160x130 box and supports null child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: DeviceFrame(
                type: DeviceType.phone,
                accent: Colors.blue,
                child: null,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(DeviceFrame), findsOneWidget);
      final frameSize = tester.getSize(find.byType(DeviceFrame));
      expect(frameSize.width, equals(160.0));
      expect(frameSize.height, equals(130.0));
    });

    testWidgets('DeviceFrame renders desktop variant with monitor and stand', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: DeviceFrame(
                type: DeviceType.desktop,
                accent: Colors.teal,
                child: null,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(DeviceFrame), findsOneWidget);
      final frameSize = tester.getSize(find.byType(DeviceFrame));
      expect(frameSize.width, equals(160.0));
      expect(frameSize.height, equals(130.0));
    });

    testWidgets('DeviceFrame renders web variant with browser dots and URL bar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: DeviceFrame(
                type: DeviceType.web,
                accent: Colors.amber,
                child: null,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(DeviceFrame), findsOneWidget);
      final frameSize = tester.getSize(find.byType(DeviceFrame));
      expect(frameSize.width, equals(160.0));
      expect(frameSize.height, equals(130.0));
    });
  });
}
