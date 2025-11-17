// lib/features/sales_register_details/repository/sales_register_details_repository.dart

import 'dart:convert';
import '../../../../../core/api/api_client.dart';
import '../model/sales_register_details_model.dart';

class SalesRegisterDetailsRepository {
  final ApiClient apiClient;

  SalesRegisterDetailsRepository({required this.apiClient});

  Future<SalesRegisterResponse> fetchSalesRegisterDetails({
    required String startDate,
    required String endDate,
  }) async {
    final payload = {
      'start_date': startDate,
      'end_date': endDate,
    };

    try {
      final url='sales-register-details';
      final response =
      await apiClient.post(url, payload);

      final decode = jsonDecode(response.body);

      if (decode == null) {
        throw Exception('Empty response from server');
      }

      if (decode is Map<String, dynamic>) {
        return SalesRegisterResponse.fromJson(decode);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      // Rethrowing allows the BLoC to catch and handle the error.
      rethrow;
    }
  }
}