import 'dart:convert';
import '../../../../../core/api/api_client.dart';
import '../model/sales_register_details_model.dart';

class SalesRegisterRepository {
  final ApiClient apiClient;

  SalesRegisterRepository({required this.apiClient});

  Future<SalesRegisterDetailsModel> fetchSalesRegister({
    required String startDate,
    required String endDate,
  }) async {
    final payload = {
      'start_date': startDate,
      'end_date': endDate,
    };

    const url = 'sales-register';

    try {
      final res = await apiClient.post(url, payload);
      final Map<String, dynamic> data = jsonDecode(res.body);

      return SalesRegisterDetailsModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch sales register: $e');
    }
  }
}
