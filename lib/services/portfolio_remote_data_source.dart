import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:portfolio_new/config/portfolio_config.dart';

class PortfolioRemoteDataSource {
  final Dio _dio;

  PortfolioRemoteDataSource({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: PortfolioConfig.timeout,
              receiveTimeout: PortfolioConfig.timeout,
              headers: {'Accept': 'application/json'},
              responseType: ResponseType.plain,
            ),
          );

  /// Fetch remote JSON string from the configured raw URL.
  Future<String> fetchRemotePortfolioJson({String? overrideUrl}) async {
    final url = overrideUrl ?? PortfolioConfig.jsonUrl;
    final response = await _dio.get<String>(url);

    if (response.statusCode != 200 || response.data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message:
            'Failed to fetch portfolio.json with status ${response.statusCode}',
      );
    }

    final rawJson = response.data!;
    // Basic verification that content is non-empty and decodable JSON
    final decoded = jsonDecode(rawJson);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Remote payload is not a valid JSON object');
    }

    return rawJson;
  }
}
