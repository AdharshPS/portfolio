import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class NavigationServices {
  static void push({
    required BuildContext context,
    required String path,
    Map<String, dynamic>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) {
    String finalPath = path;
    pathParameters?.forEach((key, value) {
      finalPath = finalPath.replaceAll(
        ':$key',
        Uri.encodeComponent(value.toString()),
      );
    });
    context.go(
      Uri(path: finalPath, queryParameters: queryParameters).toString(),
    );
  }
}
