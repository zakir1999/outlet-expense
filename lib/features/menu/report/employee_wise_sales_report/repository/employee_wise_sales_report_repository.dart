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
        "employee_id": id,

      };
      final url = 'employee-wise-sales';
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



  Future<List<EmployeeItem>> fetchEmployee({int limit = 10}) async {
    final url = 'employee?page=undefined&limit=$limit';
    final response = await apiClient.get(url);
    return _parseListResponse(response);
  }


  Map<String, dynamic> _parseResponse(dynamic response) {
    if (response == null) return {};
    if (response is Map<String, dynamic>) return response;
    if (response is String) return jsonDecode(response);
    try {
      return jsonDecode(response.body);
    } catch (_) {
      return {};
    }
  }
  List<EmployeeItem> _parseListResponse(dynamic response) {
    final data = _parseResponse(response);
    final List items = (data['data'] is Map && data['data']['data'] is List)
        ? data['data']['data']
        : [];

    return items.map<EmployeeItem>((item) {
      return EmployeeItem(
        id: item["id"] ?? 0,
        name: item["name"] ?? "",
      );
    }).toList();
  }

}