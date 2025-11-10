import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../../core/api/api_client.dart';
import '../model/sales_report_model.dart';

class ReportRepository {
  final ApiClient apiClient;

  ReportRepository({required this.apiClient});

  /// Returns full response including totals
  Future<ReportResponse> fetchReportDataResponse({
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
        return ReportResponse.fromJson(decoded);
      } else {
        throw Exception(decoded["message"] ?? "Failed to fetch report data.");
      }
    } catch (e) {
      debugPrint("❌ Report Repository Error: $e");
      rethrow;
    }
  }
}
