import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../../core/api/api_client.dart';
import '../model/category_sales_report_model.dart';

class CategorySaleRepository {
  final ApiClient apiClient;
  bool _isLoading=false;


  final Map<String, CategorySaleResponse> _cache = {};

  CategorySaleRepository({required this.apiClient});
  String _cacheKey(String start, String end, String filter, String brandId) {
    return "$start|$end|$filter|$brandId";
  }

  Future<CategorySaleResponse> fetchCategorySaleResponse({
    required String startDate,
    required String endDate,
    required String filter,
    required String brandId,
  }) async {

    final key = _cacheKey(startDate, endDate, filter, brandId);
    if (_cache.containsKey(key)) {
      debugPrint("⚡ Returning cached category sale report");
      return _cache[key]!;
    }
    if (_isLoading) {
      debugPrint("⏳ Request is already running, skipping duplicate call");
      return Future.error("Request already running");
    }
    _isLoading=true;
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
        final parsedResponse =CategorySaleResponse.fromJson(decoded);
        _cache[key] = parsedResponse;
        return parsedResponse;

      } else {
        throw Exception(decoded["message"] ?? "Failed to fetch report data.");
      }
    } catch (e) {
      debugPrint("❌ Category Sale Repository Error: $e");
      rethrow;
    }
    finally{
      _isLoading=false;
    }
  }
}
