import 'dart:convert';
import '../../../../../core/api/api_client.dart';
import '../model/invoice_model.dart';

class InvoiceRepository {
  final ApiClient apiClient;
  InvoiceRepository({required this.apiClient});

  Future<List<Invoice>> fetchInvoice({
    required int page,
    required int limit,
    String type="Inv",
  }) async {
    final endpoint=(type=='Pur')?'purchase-invoice-list': 'invoice-list';
    final url = '$endpoint?page=$page&limit=$limit';
    final res = await apiClient.get(url);
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch invoices');
    }
    final body = json.decode(res.body);

    List<dynamic> list = [];
    try {
      if (body['data'] is Map && body['data']['data'] is List) {
        list = body['data']['data'];
      } else if (body['data'] is List) {
        list = body['data'];
      } else if (body['invoices'] is List) {
        list = body['invoices'];
      } else {
        body.forEach((key, value) {
          if (value is List) list = value;
        });
      }
    } catch (e) {
      throw Exception('Unexpected response format: $e');
    }

    return list.map((e) => Invoice.fromJson(e)).toList();
  }

  Future<Invoice> fetchInvoiceById(String id) async {
    final invoices = await fetchInvoice(page: 1, limit: 1);
    return invoices.firstWhere(
          (i) => i.id == id,
      orElse: () => Invoice(
        id: id,
        customerName: 'Unknown',
        amount: 0,
        type: 'Inv',
        createdAt: '',
      ),
    );
  }
}
