
import 'dart:convert';

import '../model/imei_model.dart';

class ImeiSerialReportRepository {

  final dynamic apiClient;
  static const String endpoint = 'imei-serial-stock-report';

  ImeiSerialReportRepository({required this.apiClient});

  Future<Map<String, List<ImeiSerialRecord>>> fetchImeiReport(Map<String, dynamic> payload) async {
    final response = await apiClient.post(endpoint, payload);

    if (response == null) throw Exception('Null response from API');

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (data['success'] == true || data['status'] == 200) {
      final Map<String, dynamic> reportData = data['data'] ?? {};
      final Map<String, List<ImeiSerialRecord>> result = {};

      reportData.forEach((productName, list) {
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
      throw Exception(data['message'] ?? 'Failed to fetch report');
    }
  }



  Future<List<String>> fetchCustomerList() async {

    final response = await apiClient.get('customer-lists?page=1&limit=10');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      final List customers = data['data']['data'] ?? [];

      return customers
          .map<String>((c) => c['name']?.toString() ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
    } else {
      throw Exception('Failed to load customer list');
    }
  }
  Future<List<String>> fetchVendorList() async {
    final response = await apiClient.post('search-vendor?page=1&limit=10',"");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      final List customers = data['data']['data'] ?? [];

      return customers
          .map<String>((c) => c['name']?.toString() ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
    } else {
      throw Exception('Failed to load customer list');
    }
  }


  Future<List<String>> fetchProductList() async {

    final response = await apiClient.get('product?page=1&limit=10');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      final List customers = data['data']['data'] ?? [];

      return customers
          .map<String>((c) => c['name']?.toString() ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
    } else {
      throw Exception('Failed to load customer list');
    }
  }
  Future<List<String>> fetchBrandList() async {

    final response = await apiClient.get('brands?page=1&limit=10');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      final List customers = data['data']['data'] ?? [];

      return customers
          .map<String>((c) => c['name']?.toString() ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
    } else {
      throw Exception('Failed to load customer list');
    }
  }
}
