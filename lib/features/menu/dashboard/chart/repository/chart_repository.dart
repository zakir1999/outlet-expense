import 'dart:convert';
import '../../../../../core/api/api_client.dart';
import '../model/chart_model.dart';

class ChartRepository {
  final ApiClient apiClient;

  ChartRepository({required this.apiClient});

  Future<ChartData> fetchChartData(String interval) async {
    final response = await apiClient.get('web-dashboard?interval=$interval');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final dashboardData = jsonResponse['data'];
      return ChartData.fromJson(dashboardData);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please log in again.');
    } else {
      throw Exception('Failed to fetch chart data: ${response.body}');
    }
  }
}
