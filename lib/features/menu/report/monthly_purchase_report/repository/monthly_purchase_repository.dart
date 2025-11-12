import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../../core/api/api_client.dart';
import '../model/monthly_purchase_report_model.dart';

class MonthlyPurchaseRepository {
  final ApiClient apiClient;

  MonthlyPurchaseRepository({required this.apiClient});

  Future<MonthlyPurchaseDayCountModel> fetchMonthlyPurchase({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final payload = {
        "start_date": startDate,
        "end_date": endDate,

      };
      final url='purchase-summary-report';
      final response = await apiClient.post(url, payload);
      final decoded = jsonDecode(response.body);
      if (decoded == null) {
        throw Exception("Empty response from server.");
      }

      if (decoded['success'] == true) {
        return MonthlyPurchaseDayCountModel.fromJson(decoded);
      } else {
        throw Exception(decoded['message'] ?? "Failed to fetch report data.");
      }
    } catch (e) {
      debugPrint("❌ MonthlySalesRepository Error: $e");
      rethrow;
    }
  }
}
