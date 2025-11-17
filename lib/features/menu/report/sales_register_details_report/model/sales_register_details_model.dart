
class SalesRegisterItem {
  final String createdAt;
  final String invoiceId;
  final int qty;
  final String customerName;
  final String productName;
  final int subTotal;
  final int grandNetTotal;

  SalesRegisterItem({
    required this.createdAt,
    required this.invoiceId,
    required this.qty,
    required this.customerName,
    required this.productName,
    required this.subTotal,
    required this.grandNetTotal,
  });

  factory SalesRegisterItem.fromJson(Map<String, dynamic> json, int grandTotal) {
    final details = json["sales_details"] != null && (json["sales_details"] as List).isNotEmpty
        ? json["sales_details"][0]
        : null;

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return double.tryParse(value)?.toInt() ?? 0;
      return 0;
    }

    return SalesRegisterItem(
      createdAt: json["created_at"] ?? "",
      invoiceId: json["invoice_id"] ?? "",
      customerName: json["customer_name"] ?? "",
      productName: details?["product_info"]?["name"] ?? "N/A",
      qty: details != null ? parseInt(details["qty"]) : 0,
      subTotal: parseInt(json["sub_total"]),
      grandNetTotal: grandTotal,
    );
  }
}

class SalesRegisterResponse {
  final List<SalesRegisterItem> data;
  final int grandNetTotal;

  SalesRegisterResponse({
    required this.data,
    required this.grandNetTotal,
  });

  factory SalesRegisterResponse.fromJson(Map<String, dynamic> json) {
    final grandTotal = json["grand_net_total"] != null
        ? (json["grand_net_total"] is int
        ? json["grand_net_total"]
        : int.tryParse(json["grand_net_total"].toString()) ?? 0)
        : 0;

    final dataList = (json["data"] as List<dynamic>? ?? [])
        .map((item) => SalesRegisterItem.fromJson(item, grandTotal))
        .toList();

    return SalesRegisterResponse(
      data: dataList,
      grandNetTotal: grandTotal,
    );
  }
}