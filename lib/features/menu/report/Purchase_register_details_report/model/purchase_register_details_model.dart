class PurchaseRegisterItem {
  final String createdAt;
  final String invoiceId;
  final int qty;
  final String vendorName;
  final String productName;
  final int subTotal;
  final int grandNetTotal;

  PurchaseRegisterItem({
    required this.createdAt,
    required this.invoiceId,
    required this.qty,
    required this.vendorName,
    required this.productName,
    required this.subTotal,
    required this.grandNetTotal,
  });

  factory PurchaseRegisterItem.fromJson(Map<String, dynamic> json, int grandTotal) {
    final details = json["purchase_details"] != null && (json["purchase_details"] as List).isNotEmpty
        ? json["purchase_details"][0]
        : null;

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return PurchaseRegisterItem(
      createdAt: json["created_at"] ?? "",
      invoiceId: json["invoice_id"] ?? "",
      vendorName: json["vendor_name"] ?? "",
      productName: details?["product_info"]?["name"] ?? "",
      qty: details != null ? parseInt(details["qty"]) : 0,
      subTotal: parseInt(json["sub_total"]),
      grandNetTotal: grandTotal,
    );
  }
}

class PurchaseRegisterResponse {
  final List<PurchaseRegisterItem> data;
  final int grandNetTotal;

  PurchaseRegisterResponse({
    required this.data,
    required this.grandNetTotal,
  });

  factory PurchaseRegisterResponse.fromJson(Map<String, dynamic> json) {
    final grandTotal = json["grand_net_total"] != null
        ? (json["grand_net_total"] is int
        ? json["grand_net_total"]
        : int.tryParse(json["grand_net_total"].toString()) ?? 0)
        : 0;

    final dataList = (json["data"] as List<dynamic>? ?? [])
        .map((item) => PurchaseRegisterItem.fromJson(item, grandTotal))
        .toList();

    return PurchaseRegisterResponse(
      data: dataList,
      grandNetTotal: grandTotal,
    );
  }
}
