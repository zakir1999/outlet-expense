import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../../../../../core/api/api_client.dart';
import '../model/sales_register_details_model.dart';

class SalesRegisterRepository {
  final ApiClient apiClient;
  bool _isloading=false;
  final Map<String, SalesRegisterModel> _cache = {};

  SalesRegisterRepository({required this.apiClient});
  String _cacheKey(String start, String end) {
    return "$start|$end";
  }

    Future<SalesRegisterModel> fetchSalesRegister({
    required String startDate,
    required String endDate,
  }) async {
      final key = _cacheKey(startDate, endDate);
      if (_cache.containsKey(key)) {
        debugPrint("⚡ Returning cached sales register report");
        return _cache[key]!;
      }
      if (_isloading) {
        debugPrint("⏳ Request is already running, skipping duplicate call");
        return Future.error("Request already running");
      }
      _isloading=true;


    const url = 'sales-register';

    try {

      final payload = {
        'start_date': startDate,
        'end_date': endDate,
      };
      final res = await apiClient.post(url, payload);
      final decoded= jsonDecode(res.body);

      if(decoded["success"] == true && decoded["data"]!=null){
        final parseResponse =SalesRegisterModel.fromJson(decoded);
        _cache[key]=parseResponse;
        return parseResponse;
      }else{
        throw Exception(decoded["message"] ?? "Failed to fetch report data.");
      }
    } catch (e) {
      debugPrint("❌Sales Report Repository Error: $e");
      rethrow;
    }
    finally{
      _isloading=false;
    }
  }
}
