import 'dart:convert';
import '../../../../../core/api/api_client.dart';
import '../model/purchase_register_details_model.dart';

class PurchaseRegisterDetailsRepository {
  final ApiClient apiClient;

  PurchaseRegisterDetailsRepository({required this.apiClient});

  Future<PurchaseRegisterResponse> fetchPurchaseRegisterDetails({
    required String startDate,
    required String endDate,
  }) async {
    final payload = {
      'start_date': startDate,
      'end_date': endDate,
    };

    try {
      final response =
      await apiClient.post('purchase-register-details', payload);

      final decode = jsonDecode(response.body);

      if (decode == null) {
        throw Exception('Empty response from server');
      }

      if (decode is Map<String, dynamic>) {
        return PurchaseRegisterResponse.fromJson(decode);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      rethrow;
    }
  }
}
