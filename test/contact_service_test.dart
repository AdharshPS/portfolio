import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_new/services/contact_service.dart';

class MockSuccessAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final responsePayload = jsonEncode({
      'success': true,
      'message': 'Form submitted successfully',
    });
    return ResponseBody.fromString(
      responsePayload,
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class MockErrorAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final responsePayload = jsonEncode({
      'success': false,
      'message': 'Invalid access key',
    });
    return ResponseBody.fromString(
      responsePayload,
      400,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('ContactService Tests', () {
    test('succeeds with valid submission', () async {
      final dio = Dio();
      dio.httpClientAdapter = MockSuccessAdapter();
      final service = ContactService(dio: dio);

      final result = await service.sendMessage(
        name: 'John Doe',
        email: 'john@example.com',
        message: 'Hello, this is a test message!',
      );

      expect(result.isSuccess, isTrue);
      expect(result.message, 'Form submitted successfully');
    });

    test('fails gracefully when API returns error', () async {
      final dio = Dio();
      dio.httpClientAdapter = MockErrorAdapter();
      final service = ContactService(dio: dio);

      final result = await service.sendMessage(
        name: 'John Doe',
        email: 'john@example.com',
        message: 'Hello, this is a test message!',
      );

      expect(result.isSuccess, isFalse);
      expect(result.message, 'Invalid access key');
    });

    test('fails if access key is empty', () async {
      final service = ContactService();
      final result = await service.sendMessage(
        name: 'John Doe',
        email: 'john@example.com',
        message: 'Hello, this is a test message!',
        accessKey: '',
      );

      expect(result.isSuccess, isFalse);
      expect(result.message, contains('not configured'));
    });
  });
}
