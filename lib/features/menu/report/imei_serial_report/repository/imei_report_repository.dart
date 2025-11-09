//
// import 'dart:convert';
//
// import '../model/imei_model.dart';
//
// class ImeiSerialReportRepository {
//
//   final dynamic apiClient;
//   static const String endpoint = 'imei-serial-stock-report';
//
//   ImeiSerialReportRepository({required this.apiClient});
//
//   Future<Map<String, List<ImeiSerialRecord>>> fetchImeiReport(Map<String, dynamic> payload) async {
//     final response = await apiClient.post(endpoint, payload);
//
//     if (response == null) throw Exception('Null response from API');
//
//     final Map<String, dynamic> data = jsonDecode(response.body);
//
//     if (data['success'] == true || data['status'] == 200) {
//       final Map<String, dynamic> reportData = data['data'] ?? {};
//       final Map<String, List<ImeiSerialRecord>> result = {};
//
//       reportData.forEach((productName, list) {
//         if (list is List) {
//           final records = list.map<ImeiSerialRecord>((e) {
//             if (e is Map<String, dynamic>) {
//               return ImeiSerialRecord.fromJson(e);
//             } else {
//               return ImeiSerialRecord.fromJson(Map<String, dynamic>.from(e));
//             }
//           }).toList();
//           result[productName] = records;
//         } else {
//           result[productName] = [];
//         }
//       });
//
//       return result;
//     } else {
//       throw Exception(data['message'] ?? 'Failed to fetch report');
//     }
//   }
//
//
//
//   Future<List<String>> fetchCustomerList(
//   {required int page,required int limit}
//       ) async {
//
//     final url='customer-lists?page=$page&limit=$limit';
//     final response = await apiClient.get(url);
//
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = jsonDecode(response.body);
//
//       final List customers = data['data']['data'] ?? [];
//
//       return customers
//           .map<String>((c) => c['name']?.toString() ?? '')
//           .where((name) => name.isNotEmpty)
//           .toList();
//     } else {
//       throw Exception('Failed to load customer list');
//     }
//   }
//   Future<List<String>> fetchVendorList(
//       {required int page,required int limit}
//       ) async {
//     final response = await apiClient.post('search-vendor?page=$page&limit=$limit',"");
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = jsonDecode(response.body);
//
//       final List customers = data['data']['data'] ?? [];
//
//       return customers
//           .map<String>((c) => c['name']?.toString() ?? '')
//           .where((name) => name.isNotEmpty)
//           .toList();
//     } else {
//       throw Exception('Failed to load customer list');
//     }
//   }
//
//
//   Future<List<String>> fetchProductList(
//       {required int page,required int limit}
//       ) async {
//
//     final response = await apiClient.get('product?page=$page&limit=$limit');
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = jsonDecode(response.body);
//
//       final List customers = data['data']['data'] ?? [];
//
//       return customers
//           .map<String>((c) => c['name']?.toString() ?? '')
//           .where((name) => name.isNotEmpty)
//           .toList();
//     } else {
//       throw Exception('Failed to load customer list');
//     }
//   }
//   Future<List<String>> fetchBrandList(
//       {required int page,required int limit}
//       ) async {
//
//     final response = await apiClient.get('brands?page=$page&limit=$limit');
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = jsonDecode(response.body);
//
//       final List customers = data['data']['data'] ?? [];
//
//       return customers
//           .map<String>((c) => c['name']?.toString() ?? '')
//           .where((name) => name.isNotEmpty)
//           .toList();
//     } else {
//       throw Exception('Failed to load customer list');
//     }
//   }
// }
import 'dart:convert';
import '../model/imei_model.dart';

class ImeiSerialReportRepository {
  final dynamic apiClient;
  static const String endpoint = 'imei-serial-stock-report';

  ImeiSerialReportRepository({required this.apiClient});

  Future<Map<String, List<ImeiSerialRecord>>> fetchImeiReport(Map<String, dynamic> payload) async {
    final response = await apiClient.post(endpoint, payload);
    if (response == null) throw Exception('Null response from API');

    // response may be http.Response or already-decoded Map depending on apiClient impl
    Map<String, dynamic> data;
    if (response is String) {
      data = jsonDecode(response);
    } else if (response is Map) {
      data = Map<String, dynamic>.from(response);
    } else {
      data = jsonDecode(response.body);
    }

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

  // helper to parse response bodies that may be http.Response or decoded
  Map<String, dynamic> _readBody(dynamic response) {
    if (response == null) return {};
    if (response is Map<String, dynamic>) return response;
    if (response is String) return jsonDecode(response);
    try {
      return jsonDecode(response.body);
    } catch (_) {
      return {};
    }
  }

  Future<List<String>> fetchCustomerList({required int page, required int limit}) async {
    final url = 'customer-lists?page=$page&limit=$limit';
    final response = await apiClient.get(url);

    final data = _readBody(response);
    final List customers = (data['data'] is Map && data['data']['data'] is List)
        ? data['data']['data']
        : (data['data'] is List ? data['data'] : []);

    return customers
        .map<String>((c) => (c is Map && c['name'] != null) ? c['name'].toString() : c.toString())
        .where((name) => name.isNotEmpty)
        .toList();
  }

  Future<List<String>> fetchVendorList({required int page, required int limit}) async {
    final url = 'search-vendor?page=$page&limit=$limit';
    final response = await apiClient.post(url, "");

    final data = _readBody(response);
    final List customers = (data['data'] is Map && data['data']['data'] is List)
        ? data['data']['data']
        : (data['data'] is List ? data['data'] : []);

    return customers
        .map<String>((c) => (c is Map && c['name'] != null) ? c['name'].toString() : c.toString())
        .where((name) => name.isNotEmpty)
        .toList();
  }

  Future<List<String>> fetchProductList({required int page, required int limit}) async {
    final url = 'product?page=$page&limit=$limit';
    final response = await apiClient.get(url);

    final data = _readBody(response);
    final List items = (data['data'] is Map && data['data']['data'] is List)
        ? data['data']['data']
        : (data['data'] is List ? data['data'] : []);

    return items
        .map<String>((c) => (c is Map && c['name'] != null) ? c['name'].toString() : c.toString())
        .where((name) => name.isNotEmpty)
        .toList();
  }

  Future<List<String>> fetchBrandList({required int page, required int limit}) async {
    final url = 'brands?page=$page&limit=$limit';
    final response = await apiClient.get(url);

    final data = _readBody(response);
    final List items = (data['data'] is Map && data['data']['data'] is List)
        ? data['data']['data']
        : (data['data'] is List ? data['data'] : []);

    return items
        .map<String>((c) => (c is Map && c['name'] != null) ? c['name'].toString() : c.toString())
        .where((name) => name.isNotEmpty)
        .toList();
  }
}
