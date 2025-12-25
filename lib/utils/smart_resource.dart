import 'package:dio/dio.dart';

class SmartResource<T> {
  T? _cache;
  DateTime? _lastFetchTime;
  CancelToken? _cancelToken;

  final Duration cacheDuration;

  SmartResource({this.cacheDuration = const Duration(minutes: 2)});

  Future<T> getOrFetch({
    required Future<T> Function(CancelToken token) fetcher,
    bool forceRefresh = false,
  }) async {

    if (!forceRefresh && _cache != null && _lastFetchTime != null) {
      if (DateTime.now().difference(_lastFetchTime!) < cacheDuration) {
        return _cache!;
      }
    }

    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel("ยกเลิกเพราะมีคำสั่งใหม่");
    }
    _cancelToken = CancelToken();

    try {
      final result = await fetcher(_cancelToken!);
      _cache = result;
      _lastFetchTime = DateTime.now();

      return result;
    } catch (e) {
      if (e is DioException && CancelToken.isCancel(e)) {
        throw Exception("Request Cancelled");
      }
      rethrow;
    }
  }

  void clearCache() {
    _cache = null;
    _lastFetchTime = null;
  }
}