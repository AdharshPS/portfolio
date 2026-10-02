class PortfolioConfig {
  static const String _env = String.fromEnvironment('ENV', defaultValue: 'dev');

  /// The remote URL from which portfolio.json is loaded.
  /// Defaults to the dev branch when ENV=dev, and main branch when ENV=prod.
  /// Overridable via `--dart-define=PORTFOLIO_JSON_URL=<url>`
  static const String jsonUrl = String.fromEnvironment(
    'PORTFOLIO_JSON_URL',
    defaultValue: _env == 'prod'
        ? 'https://raw.githubusercontent.com/AdharshPS/portfolio_new/main/portfolio.json'
        : 'https://raw.githubusercontent.com/AdharshPS/portfolio_new/dev/portfolio.json',
  );

  /// Storage key for the cached portfolio JSON payload.
  static const String cacheKey = 'portfolio_data_cache';

  /// Storage key for the timestamp when portfolio.json was last cached.
  static const String cacheTimestampKey = 'portfolio_data_cache_timestamp';

  /// Network request timeout.
  static const Duration timeout = Duration(seconds: 10);
}
