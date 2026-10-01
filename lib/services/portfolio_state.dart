import 'package:portfolio_new/models/portfolio_model.dart';
import 'package:portfolio_new/services/portfolio_repository.dart';

enum PortfolioStatus {
  initial,
  loading,
  loaded,
  refreshing,
  error,
  offlineCached,
}

class PortfolioState {
  final PortfolioStatus status;
  final PortfolioData data;
  final DataSource dataSource;
  final String? errorMessage;
  final DateTime? lastUpdated;

  const PortfolioState({
    required this.status,
    required this.data,
    required this.dataSource,
    this.errorMessage,
    this.lastUpdated,
  });

  factory PortfolioState.initial([PortfolioData? initialData]) {
    return PortfolioState(
      status: PortfolioStatus.initial,
      data: initialData ?? PortfolioData.defaults(),
      dataSource: DataSource.hardcoded,
    );
  }

  PortfolioState copyWith({
    PortfolioStatus? status,
    PortfolioData? data,
    DataSource? dataSource,
    String? errorMessage,
    DateTime? lastUpdated,
    bool clearError = false,
  }) {
    return PortfolioState(
      status: status ?? this.status,
      data: data ?? this.data,
      dataSource: dataSource ?? this.dataSource,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
