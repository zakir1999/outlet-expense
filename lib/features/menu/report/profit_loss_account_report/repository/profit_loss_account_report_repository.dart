
import 'dart:convert';
import '../../../../../core/api/api_client.dart';
import '../model/profit_loss_account_report_model.dart';

class ProfitLossReportRepository {
  final ApiClient apiClient;

  ProfitLossReportRepository({required this.apiClient});

  Future<ProfitLossReport> fetchProfitLossReport({
    required String startDate,
    required String endDate,
  }) async {
    final payload = {
      'start_date': startDate,
      'end_date': endDate,
    };

    try {
      final response = await apiClient.post('profit-loss-report', payload);

      final decode = jsonDecode(response.body);

      if (decode == null || decode['success'] != true || decode['data'] == null) {
        throw Exception(decode['message'] ?? 'Failed to load report');
      }

      if (decode['data'] is Map<String, dynamic>) {
        return ProfitLossReport.fromJson(decode['data']);
      } else {
        throw Exception('Unexpected data format in response');
      }
    } catch (e) {
      rethrow;
    }
  }
}