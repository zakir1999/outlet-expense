import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../../../core/api/api_client.dart';
import '../sales_model/sales_report_model.dart';



class ReportRepository {
  final ApiClient apiClient;

  ReportRepository({required this.apiClient});

  /// Fetch report data between startDate and endDate with optional brand and filter
  Future<List<ReportModel>> fetchReportData({
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

      // use the shared ApiClient to post the data
      final response = await apiClient.post(
        "sale-summary-report", // ✅ endpoint only, no base URL needed
        payload,
      );

      final decoded = jsonDecode(response.body);

      if (decoded["success"] == true && decoded["data"] != null) {
        final List<dynamic> list = decoded["data"];
        return list.map((e) => ReportModel.fromJson(e)).toList();
      } else {
        throw Exception(decoded["message"] ?? "Failed to fetch report data.");
      }
    } catch (e) {
      debugPrint("❌ ReportRepository Error: $e");
      rethrow;
    }
  }
}
