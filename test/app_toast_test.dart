import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_new/widgets/app_toast.dart';

void main() {
  Widget buildTestScaffold({required Widget child}) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  testWidgets('AppToast displays message and icon properly', (tester) async {
    await tester.pumpWidget(
      buildTestScaffold(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => AppToast.success(context, 'Changes saved successfully', title: 'Success'),
            child: const Text('Show Toast'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show Toast'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Changes saved successfully'), findsOneWidget);
    expect(find.text('Success'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

    // Dismiss manually
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Changes saved successfully'), findsNothing);
  });

  testWidgets('AppToast replaces previous toast without overlap', (tester) async {
    await tester.pumpWidget(
      buildTestScaffold(
        child: Builder(
          builder: (context) => Column(
            children: [
              ElevatedButton(
                onPressed: () => AppToast.info(context, 'First message'),
                child: const Text('First'),
              ),
              ElevatedButton(
                onPressed: () => AppToast.error(context, 'Second error message'),
                child: const Text('Second'),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('First'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('First message'), findsOneWidget);

    await tester.tap(find.text('Second'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Second error message'), findsOneWidget);
    expect(find.text('First message'), findsNothing);

    // Clean up
    AppToast.dismiss();
    await tester.pump(const Duration(milliseconds: 300));
  });
}
