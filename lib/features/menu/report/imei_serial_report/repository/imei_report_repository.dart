import 'dart:async';

import '../model/imei_model.dart';

class ImeiSerialReportRepository {
  final dynamic apiClient;
  static const String endpoint = 'imei-serial-stock-report';
  ImeiSerialReportRepository({required this.apiClient});
  Future<Map<String, List<ImeiSerialRecord>>> fetchImeiReport(Map<String, dynamic> payload) async {
    final response = await apiClient.post(endpoint, payload);
    if (response == null) {
      throw Exception('Null response from API');
    }
    if (response is Map && (response['success'] == true || response['status'] == 200)) {
      final data = response['data'] as Map<String, dynamic>? ?? {};
      final Map<String, List<ImeiSerialRecord>> result = {};
      data.forEach((productName, list) {
        if (list is List) {
          final records = list.map<ImeiSerialRecord>((e) {
            if (e is Map<String, dynamic>) {
              return ImeiSerialRecord.fromJson(e);
            } else {
              return ImeiSerialRecord.fromJson(Map<String, dynamic>.from(e));
            }
          }).toList();
          result[productName] = records;
        } else {
          result[productName] = [];
        }
      });
      return result;
    } else {
      final message = response['message'] ?? 'Failed to fetch report';
      throw Exception(message);
    }
  }
  Future<List<String>> fetchCustomerList() async {
    final data = await apiClient.get('customer-lists?page=1&limit=10');

    if (data is List) {
      return data.map((e) => e.toString()).toList();
    }

    if (data is Map && data.containsKey('data')) {
      final list = data['data'];
      if (list is List) {
        return list.map((e) => e.toString()).toList();
      }
    }

    throw Exception('Unexpected response format');
  }
}
