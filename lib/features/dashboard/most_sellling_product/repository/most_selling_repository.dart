import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/api/api_client.dart';
import '../model/most_selling_model.dart';

class MostSellingRepository {
  final ApiClient apiClient;

  MostSellingRepository({required this.apiClient});

  Future<List<MostSellingProduct>> fetchMostSellingProducts() async {
    try {
      final http.Response response = await apiClient.get('top-sales');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          final dataContainer = decoded['data'];

          // Case 1: The product list is inside data["data"]
          if (dataContainer is Map<String, dynamic> &&
              dataContainer['data'] is List) {
            final List dataList = dataContainer['data'];
            return dataList
                .map((e) => MostSellingProduct.fromJson(e))
                .toList();
          }

          // Case 2: The API directly returns a list inside "data"
          if (dataContainer is List) {
            return dataContainer
                .map((e) => MostSellingProduct.fromJson(e))
                .toList();
          }

          // Case 3: Single product object inside "data"
          if (dataContainer is Map<String, dynamic>) {
            return [MostSellingProduct.fromJson(dataContainer)];
          }
        }

        throw Exception('Unexpected data format in API response.');
      } else {
        throw Exception(
          'Failed to load products. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load most selling products: $e');
    }
  }
}
