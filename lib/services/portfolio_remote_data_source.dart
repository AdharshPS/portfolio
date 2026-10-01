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

  /// Fetch remote JSON string from the configured raw URL with cache-busting.
  Future<String> fetchRemotePortfolioJson({String? overrideUrl}) async {
    final baseUrl = overrideUrl ?? PortfolioConfig.jsonUrl;

    // Append cache-busting timestamp to prevent browser & CDN stale responses
    final uri = Uri.parse(baseUrl);
    final queryParams = Map<String, dynamic>.from(uri.queryParameters);
    queryParams['_t'] = DateTime.now().millisecondsSinceEpoch.toString();
    final cacheBustedUrl = uri.replace(queryParameters: queryParams).toString();

    final response = await _dio.get<String>(cacheBustedUrl);

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
