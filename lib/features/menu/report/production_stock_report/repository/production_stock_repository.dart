import '../../../../../core/api/api_client.dart';
import '../model/production_stock_model.dart';
import 'dart:convert';

class ProductionStockRepository {
  final ApiClient apiClient;

  ProductionStockRepository({required this.apiClient});


  Future<ProductionStockResponse> fetchProductionStock({
    required String startDate,
    required String endDate,
  }) async {
    final payload = {
      'start_date': startDate,
      'end_date': endDate,
    };
    final url='date-wise-product-stock-report-list';

    try {
      final res = await apiClient.post(url, payload);
      final decode = jsonDecode(res.body);

      if (decode == null) {
        throw Exception('Empty response from server');
      }


      if (decode is Map<String, dynamic>) {
        return ProductionStockResponse.fromJson(decode);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      rethrow;
    }
  }
}
