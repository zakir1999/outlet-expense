import 'dart:convert';
import '../../../../core/api/api_client.dart';
import '../model/purchase_invoice_model.dart';

class PurchaseInvoiceRepository {
  final ApiClient apiClient;

  PurchaseInvoiceRepository({required this.apiClient});

  Future<List<PurchaseInvoice>> fetchPurchaseInvoice({
    required int page,
    required int limit,
  }) async {
    final url = 'purchase-invoice-list?page=$page&limit=$limit';
    final res = await apiClient.get(url);

    if (res.statusCode != 200) {
      throw Exception('Failed to fetch invoices');
    }

    final body = json.decode(res.body);

    // ✅ Safely extract list of invoices
    List<dynamic> list = [];
    try {
      if (body['data'] is Map && body['data']['data'] is List) {
        list = body['data']['data'];
      } else if (body['data'] is List) {
        list = body['data'];
      } else if (body['invoices'] is List) {
        list = body['invoices'];
      } else {
        // fallback scan for list anywhere
        body.forEach((key, value) {
          if (value is List) list = value;
        });
      }
    } catch (e) {
      throw Exception('Unexpected response format: $e');
    }

    return list.map((e) => PurchaseInvoice.fromJson(e)).toList();
  }

  Future<PurchaseInvoice> fetchPurchaseInvoiceById(String id) async {
    final invoices = await fetchPurchaseInvoice(page: 1, limit: 1);
    return invoices.firstWhere(
          (i) => i.id == id,
      orElse: () => PurchaseInvoice(
        id: id,
        customerName: 'Unknown',
        amount: 0,
        type: 'Inv',
        createdAt: '',
      ),
    );
  }
}
