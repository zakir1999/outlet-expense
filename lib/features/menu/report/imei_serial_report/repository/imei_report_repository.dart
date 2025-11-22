import 'dart:convert';
import '../model/imei_model.dart';

class ImeiSerialReportRepository {
  final dynamic apiClient;
  static const String endpoint = 'imei-serial-stock-report';

  ImeiSerialReportRepository({required this.apiClient});

  // -------------------- Fetch IMEI / Serial Report --------------------
  Future<Map<String, List<ImeiSerialRecord>>> fetchReport({
    String? brandName,
    String? productName,
    String? imei,
    String? productCondition,
    String? customerName,
    String? vendorName,
    String? stockType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final payload = {
      'brand': brandName ?? '',
      'product': productName ?? '',
      'imei': imei ?? '',
      'product_condition': productCondition ?? '',
      'customer': customerName ?? '',
      'vendor': vendorName ?? '',
      'stock_type': stockType ?? '',
      'start_date': startDate?.toIso8601String() ?? '',
      'end_date': endDate?.toIso8601String() ?? '',
    };

    final response = await apiClient.post(endpoint, payload);
    if (response == null) throw Exception('Null response from API');

    final Map<String, dynamic> data = _parseResponse(response);

    if (data['success'] == true || data['status'] == 200) {
      final Map<String, dynamic> reportData = data['data'] ?? {};
      final Map<String, List<ImeiSerialRecord>> result = {};

      reportData.forEach((productName, list) {
        if (list is List) {
          final records = list.map<ImeiSerialRecord>((e) {
            if (e is Map<String, dynamic>) return ImeiSerialRecord.fromJson(e);
            return ImeiSerialRecord.fromJson(Map<String, dynamic>.from(e));
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

  // -------------------- Dropdown Fetching with Pagination --------------------
  Future<List<String>> fetchCustomers({int page = 1, int limit = 100}) async {
    final url = 'customer-lists?page=$page&limit=$limit';
    final response = await apiClient.get(url);
    return _parseListResponse(response);
  }

  Future<List<String>> fetchVendors({int page = 1, int limit = 100}) async {
    final url = 'search-vendor?page=$page&limit=$limit';
    final response = await apiClient.post(url, "");
    return _parseListResponse(response);
  }

  Future<List<String>> fetchProducts({int page = 1, int limit = 100}) async {
    final url = 'product?page=$page&limit=$limit';
    final response = await apiClient.get(url);
    return _parseListResponse(response);
  }

  Future<List<String>> fetchBrands({int page = 1, int limit = 100}) async {
    final url = 'brands?page=$page&limit=$limit';
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

  List<String> _parseListResponse(dynamic response) {
    final data = _parseResponse(response);
    final List items = (data['data'] is Map && data['data']['data'] is List)
        ? data['data']['data']
        : (data['data'] is List ? data['data'] : []);

    return items
        .map<String>((c) => (c is Map && c['name'] != null) ? c['name'].toString() : c.toString())
        .where((name) => name.isNotEmpty)
        .toList();
  }
}