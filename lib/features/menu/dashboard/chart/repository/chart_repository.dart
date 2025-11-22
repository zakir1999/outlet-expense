import 'dart:convert';
import 'dart:async';
import '../../../../../core/api/api_client.dart';
import '../model/chart_model.dart';

class ChartRepository {
  final ApiClient apiClient;

  /// In-memory cache
  final Map<String, ChartData> _cache = {};

  /// To prevent duplicate requests at the same time
  final Map<String, Future<ChartData>> _ongoingRequests = {};

  /// Optional cache expiration (5 minutes)
  final Duration cacheDuration = const Duration(minutes: 5);
  final Map<String, DateTime> _cacheTime = {};

  /// Maximum cache size (LRU cleanup)
  final int maxCacheSize = 10;

  ChartRepository({required this.apiClient});

  /// Generate cache key for scalability
  String _generateKey(String interval, {Map<String, String>? filters}) {
    if (filters == null || filters.isEmpty) return interval;
    final sortedKeys = filters.keys.toList()..sort();
    final filterString = sortedKeys.map((k) => '$k=${filters[k]}').join('|');
    return '$interval|$filterString';
  }

  Future<ChartData> fetchChartData(
      String interval, {
        Map<String, String>? filters,
      }) async {
    final key = _generateKey(interval, filters: filters);
    final now = DateTime.now();

    // ---- STEP 1: Return cached data if valid ----
    if (_cache.containsKey(key)) {
      final savedAt = _cacheTime[key];
      if (savedAt != null && now.difference(savedAt) < cacheDuration) {
        return _cache[key]!;
      }
    }

    // ---- STEP 2: Avoid duplicate API hit for same key ----
    if (_ongoingRequests.containsKey(key)) {
      return _ongoingRequests[key]!;
    }

    // ---- STEP 3: Make API call with retry ----
    final futureRequest = _fetchFromApiWithRetry(interval, filters: filters);
    _ongoingRequests[key] = futureRequest;

    try {
      final data = await futureRequest;

      _addToCache(key, data);
      return data;
    } catch (e) {
      // Offline fallback: return old cache if exists
      if (_cache.containsKey(key)) {
        return _cache[key]!;
      }
      rethrow;
    } finally {
      _ongoingRequests.remove(key);
    }
  }

  Future<ChartData> _fetchFromApiWithRetry(
      String interval, {
        Map<String, String>? filters,
        int retries = 3,
        int delayMs = 300,
      }) async {
    int attempt = 0;
    while (true) {
      try {
        return await _fetchFromApi(interval, filters: filters);
      } catch (e) {
        attempt++;
        if (attempt >= retries) {
          rethrow;
        }
        await Future.delayed(Duration(milliseconds: delayMs * attempt));
      }
    }
  }

  Future<ChartData> _fetchFromApi(String interval, {Map<String, String>? filters}) async {
    // Build query string
    String url = 'web-dashboard?interval=$interval';
    if (filters != null && filters.isNotEmpty) {
      final filterParams = filters.entries.map((e) => '${e.key}=${e.value}').join('&');
      url += '&$filterParams';
    }

    final response = await apiClient.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final dashboardData = jsonResponse['data'];
      return ChartData.fromJson(dashboardData);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please log in again.');
    } else {
      throw Exception('Failed to fetch chart data: ${response.body}');
    }
  }

  void _addToCache(String key, ChartData data) {
    if (_cache.length >= maxCacheSize) {
      // LRU cleanup: remove oldest cache
      final oldestKey = _cacheTime.entries.reduce((a, b) => a.value.isBefore(b.value) ? a : b).key;
      _cache.remove(oldestKey);
      _cacheTime.remove(oldestKey);
    }
    _cache[key] = data;
    _cacheTime[key] = DateTime.now();
  }

  /// Optional: Clear specific cache
  void clearIntervalCache(String interval, {Map<String, String>? filters}) {
    final key = _generateKey(interval, filters: filters);
    _cache.remove(key);
    _cacheTime.remove(key);
  }

  /// Optional: Clear all cache
  void clearAllCache() {
    _cache.clear();
    _cacheTime.clear();
  }
}
