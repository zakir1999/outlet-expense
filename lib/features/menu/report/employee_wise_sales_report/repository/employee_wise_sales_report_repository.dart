import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../../core/api/api_client.dart';
import '../model/employee_wise_sales_report_model.dart';

class EmployeeWiseSalesReportRepository {
  final ApiClient apiClient;

  EmployeeWiseSalesReportRepository({required this.apiClient});

  Future<EmployeeReportResponse> fetchEmployWiseSalesReport({
    required String startDate,
    required String endDate,
    required String id,
  }) async {
    try {
      final payload = {
        "start_date": startDate,
        "end_date": endDate,
        "employee_id":65 ,

      };
      final url='employee-wise-sales';
      final response = await apiClient.post(url, payload);
      final decoded = jsonDecode(response.body);
      if (decoded == null) {
        throw Exception("Empty response from server.");
      }

      if (decoded['success'] == true) {
        return EmployeeReportResponse.fromJson(decoded);
      } else {
        throw Exception(decoded['message'] ?? "Failed to fetch report data.");
      }
    } catch (e) {
      debugPrint("❌ Employee Wise Repository Error: $e");
      rethrow;
    }
  }
}
