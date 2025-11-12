class MonthlyPurchaseDayCountModel {
  final bool success;
  final String message;
  final List<MonthlyPurchaseItem> data;
  final int daysCount;
  final double grandTotal;

  MonthlyPurchaseDayCountModel({
    required this.success,
    required this.message,
    required this.data,
    required this.daysCount,
    required this.grandTotal,
  });

  factory MonthlyPurchaseDayCountModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list=json['data']?? [];
    return MonthlyPurchaseDayCountModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: list.map((e)=>MonthlyPurchaseItem.fromJson(e)).toList(),
      daysCount: json['days_count'] ?? 0,
      grandTotal: double.tryParse(json['grand_total'].toString())??0,
    );
  }
}

class MonthlyPurchaseItem {
  final String date;
  final String invoiceId;
  final String vendorName;
  final String productName;
  final int qty;
  final double price;
  final String payMode;
  final String imei;

  MonthlyPurchaseItem({
    required this.date,
    required this.invoiceId,
    required this.vendorName,
    required this.productName,
    required this.qty,
    required this.price,
    required this.payMode,
    required this.imei,
  });

  factory MonthlyPurchaseItem.fromJson(Map<String, dynamic> json) {
    return MonthlyPurchaseItem(
      date: json['date'] ?? '',
      invoiceId: json['invoice_id'] ?? '',
      vendorName: json['vendor_name'] ?? '',
      productName: json['product_name'] ?? '',
      qty: json['qty'] ?? 0,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      payMode: json['pay_mode'] ?? '',
      imei: json['imei']?.toString() ?? '',
    );
  }
}
