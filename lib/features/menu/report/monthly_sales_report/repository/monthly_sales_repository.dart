import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../../core/api/api_client.dart';
import '../model/monthly_sales_model.dart';

class MonthlySalesRepository {
  final ApiClient apiClient;

  MonthlySalesRepository({required this.apiClient});

  /// Returns full response including totals
  Future<MonthlySalesModel> fetchMonthlySaleResponse({
    required String startDate,
    required String endDate,
    required String filter,
    required String brandId,
  }) async {
    try {
      final payload = {
        "brand_id": brandId,
        "end_date": endDate,
        "filter": filter,
        "start_date": startDate,
        "vendor_id": ""
      };

      final response = await apiClient.post("sale-summary-report", payload);
      final decoded = jsonDecode(response.body);

      if (decoded["success"] == true && decoded["data"] != null) {
        return MonthlySalesModel.fromJson(decoded);
      } else {
        throw Exception(decoded["message"] ?? "Failed to fetch report data.");
      }
    } catch (e) {
      debugPrint("❌ Report Repository Error: $e");
      rethrow;
    }
  }
}
