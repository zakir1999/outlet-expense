import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../../core/api/api_client.dart';
import '../model/due_report_model.dart';

class DueReportRepository {
  final ApiClient apiClient;

  DueReportRepository({required this.apiClient});

  Future<DueReportModel> fetchDueReport({
    required String startDate,
    required String endDate,
    required String dueType,
  }) async {
    try {
      final payload = {
        "start_date": startDate,
        "end_date": endDate,
        "due":dueType,

      };
      final url='date-wise-due-list';
      final response = await apiClient.post(url, payload);
      final decoded = jsonDecode(response.body);
      if (decoded == null) {
        throw Exception("Empty response from server.");
      }

      if (decoded['success'] == true) {
        return DueReportModel.fromJson(decoded);
      } else {
        throw Exception(decoded['message'] ?? "Failed to fetch report data.");
      }
    } catch (e) {
      debugPrint("❌ Due Repository Error: $e");
      rethrow;
    }
  }
}
