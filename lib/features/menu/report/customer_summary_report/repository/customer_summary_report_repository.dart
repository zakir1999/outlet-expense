import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../../core/api/api_client.dart';
import '../model/customer_summary_report_model.dart';

class CustomerSummaryReportRepository {
  final ApiClient apiClient;

  CustomerSummaryReportRepository({required this.apiClient});

  Future<CustomerSummaryReportResponse> fetchCustomerSummaryReport({
    required String startDate,
    required String endDate,
    required String id,
  }) async {
    try {
      final payload = {
        "start_date": startDate,
        "end_date": endDate,
        "customer_id": id,

      };
      final url = 'customer-summary';
      final response = await apiClient.post(url, payload);
      final decoded = jsonDecode(response.body);
      if (decoded == null) {
        throw Exception("Empty response from server.");
      }

      if (decoded['success'] == true) {
        return CustomerSummaryReportResponse.fromJson(decoded);
      } else {
        throw Exception(decoded['message'] ?? "Failed to fetch report data.");
      }
    } catch (e) {
      debugPrint("❌ Customer Summary  Repository Error: $e");
      rethrow;
    }
  }



  Future<List<CustomerItem>> fetchCustomer({int page=1,int limit = 10}) async {
    final url = 'customer-lists?page=${page}&limit=${limit}';
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
  List<CustomerItem> _parseListResponse(dynamic response) {
    final data = _parseResponse(response);
    final List items = (data['data'] is Map && data['data']['data'] is List)
        ? data['data']['data']
        : [];

    return items.map<CustomerItem>((item) {
      return CustomerItem(
        id: item["id"] ?? 0,
        name: item["name"] ?? "",
      );
    }).toList();
  }

}