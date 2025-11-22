
import 'dart:convert';
import 'package:flutter/cupertino.dart';

import '../../../../../core/api/api_client.dart';
import '../model/profit_loss_account_report_model.dart';

class ProfitLossReportRepository {
  final ApiClient apiClient;
  bool _isLoading=false;
  final Map<String,ProfitLossReport> _cache={};

  ProfitLossReportRepository({required this.apiClient});

  String _cacheKey(String start, String end) {
    return "$start|$end";
  }

  Future<ProfitLossReport> fetchProfitLossReport({
    required String startDate,
    required String endDate,
  }) async {
    final key = _cacheKey(startDate, endDate);
    if (_cache.containsKey(key)) {
      debugPrint("⚡ Returning cached Profit Loss report");
      return _cache[key]!;
    }
    if (_isLoading) {
      debugPrint("⏳ Request is already running, skipping duplicate call");
      return Future.error("Request already running");
    }

    _isLoading = true;

    final payload = {
      'start_date': startDate,
      'end_date': endDate,
    };

    try {
      final response = await apiClient.post('profit-loss-report', payload);
      final decoded = jsonDecode(response.body);
      if (decoded == null ||
          decoded['success'] != true ||
          decoded['data'] == null) {
        throw Exception("Invalid API response format");
      }

      final parsedResponse = ProfitLossReport.fromJson(decoded['data']);
      _cache[key] = parsedResponse;

      return parsedResponse;
    } catch (e) {
      debugPrint("❌ Profit Loss Report Repository Error: $e");
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

}