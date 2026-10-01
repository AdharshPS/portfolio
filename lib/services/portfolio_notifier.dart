import 'package:flutter/foundation.dart';
import 'package:portfolio_new/services/portfolio_repository.dart';
import 'package:portfolio_new/services/portfolio_state.dart';

class PortfolioNotifier extends ChangeNotifier {
  final PortfolioRepository _repository;
  PortfolioState _state;

  PortfolioNotifier({PortfolioRepository? repository})
    : _repository = repository ?? PortfolioRepository(),
      _state = PortfolioState.initial(
        (repository ?? PortfolioRepository()).getHardcodedFallback(),
      );

  PortfolioState get state => _state;

  /// Starts non-blocking initialization:
  /// 1. Immediately renders cached/hardcoded content.
  /// 2. Fetches fresh remote data in the background.
  Future<void> initialize() async {
    // Phase 1: Load cache or hardcoded fallback immediately
    final initial = await _repository.getInitialData();
    _state = _state.copyWith(
      status: initial.source == DataSource.cache
          ? PortfolioStatus.offlineCached
          : PortfolioStatus.loaded,
      data: initial.data,
      dataSource: initial.source,
      lastUpdated: initial.timestamp,
      clearError: true,
    );
    notifyListeners();

    // Phase 2: Fetch remote in the background
    await _fetchRemoteSilently();
  }

  Future<void> _fetchRemoteSilently() async {
    try {
      final remoteResult = await _repository.fetchRemoteData();
      _state = _state.copyWith(
        status: PortfolioStatus.loaded,
        data: remoteResult.data,
        dataSource: DataSource.remote,
        lastUpdated: remoteResult.timestamp,
        clearError: true,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('⚠️ Remote fetch failed in background: $e');
      // Keep existing data; mark offline/cached if we had cached data
      _state = _state.copyWith(
        status: _state.dataSource == DataSource.cache
            ? PortfolioStatus.offlineCached
            : PortfolioStatus.loaded,
        errorMessage: 'Unable to reach remote server: $e',
      );
      notifyListeners();
    }
  }

  /// Explicit refresh triggered by user (pull to refresh or refresh button).
  /// Returns true on success, false on failure.
  Future<bool> refresh() async {
    if (_state.status == PortfolioStatus.refreshing) {
      return false;
    }

    _state = _state.copyWith(
      status: PortfolioStatus.refreshing,
      clearError: true,
    );
    notifyListeners();

    try {
      final remoteResult = await _repository.fetchRemoteData();
      _state = _state.copyWith(
        status: PortfolioStatus.loaded,
        data: remoteResult.data,
        dataSource: DataSource.remote,
        lastUpdated: remoteResult.timestamp,
        clearError: true,
      );
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('❌ Manual refresh failed: $e');
      _state = _state.copyWith(
        status: PortfolioStatus.error,
        errorMessage: 'Failed to update portfolio: $e',
      );
      notifyListeners();
      return false;
    }
  }
}
