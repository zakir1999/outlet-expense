import 'dart:convert';
import '../../../../../core/api/api_client.dart';
import '../model/cashbook_details_model.dart';

class CashbookDetailsRepository {
  final ApiClient apiClient;

  CashbookDetailsRepository({required this.apiClient});

  Future<List<PaymentTypeItem>> fetchPaymentTypes() async {
    const url = "payment-type-list?page=1&limit=100";

    final response = await apiClient.get(url);
    final decoded = jsonDecode(response.body);

    if (decoded['success'] != true) {
      throw Exception(decoded['message'] ?? "Failed to fetch payment types");
    }

    final List list = decoded['data']['data'] ?? [];
    return list.map((e) => PaymentTypeItem.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> fetchCashbookDetailsReport({
    required String startDate,
    required String endDate,
    required int paymentTypeId,
    required String orderType,
  }) async {
    final payload = {
      "start_date": startDate,
      "end_date": endDate,
      "payment_type_id": paymentTypeId,
      "view_order": orderType,
    };

    const url = "cash-book-report";

    final response = await apiClient.post(url, payload);
    final decoded = jsonDecode(response.body);

    if (decoded['success'] != true) {
      throw Exception(decoded['message'] ?? "Failed to fetch cashbook details.");
    }


    final openingBalance = _toDouble(decoded["opening_balance"]);
    final totalCredit = _toDouble(decoded["current_total_credit"]);
    final totalDebit = _toDouble(decoded["current_total_debit"]);
    final closingBalance = _toDouble(decoded["closing_balance"]);

    final items = (decoded["data"] as List)
        .map((e) => TransactionItem.fromJson(e))
        .toList();

    return {
      "data": items,
      "opening_balance": openingBalance,
      "current_total_credit": totalCredit,
      "current_total_debit": totalDebit,
      "closing_balance": closingBalance,
    };
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

}
