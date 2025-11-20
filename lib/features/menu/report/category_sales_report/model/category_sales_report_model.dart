import 'dart:convert';

/// Helper: safely parse double
double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  final str = value.toString();
  return double.tryParse(str) ?? 0.0;
}

/// Helper: safely parse int
int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  final str = value.toString();
  return int.tryParse(str) ?? 0;
}

/// 🧾 Individual report item monthly_sales_report
class CategorySaleModel {
  final String date;
  final String invoiceId;
  final String customerName;
  final String productName;
  final String paymentType;
  final int qty;
  final double price;
  final double purchasePrice;
  final double profit;
  final int orderType;
  final String? imei;

  CategorySaleModel({
    required this.date,
    required this.invoiceId,
    required this.customerName,
    required this.productName,
    required this.paymentType,
    required this.qty,
    required this.price,
    required this.purchasePrice,
    required this.profit,
    required this.orderType,
    this.imei,
  });

  factory CategorySaleModel.fromJson(Map<String, dynamic> json) {
    final price = _toDouble(json['price']);
    final purchase = _toDouble(json['purchase_price']);
    final qty = _toInt(json['qty']);
    final orderType = _toInt(json['order_type']);

    return CategorySaleModel(
      date: json['date']?.toString() ?? '',
      invoiceId: json['invoice_id']?.toString() ?? '',
      customerName: json['customer_name']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      paymentType: json['payment_type']?.toString() ?? '',
      qty: qty,
      price: price,
      purchasePrice: purchase,
      profit: price - purchase,
      orderType: orderType,
      imei: json['imei']?.toString(),
    );
  }
}

/// 📦 Top-level response monthly_sales_report (includes totals + report list)
class CategorySaleResponse {
  final bool success;
  final String message;
  final int daysCount;
  final double grandTotal;
  final double discountTotal;
  final List<CategorySaleModel> reports;

  CategorySaleResponse({
    required this.success,
    required this.message,
    required this.daysCount,
    required this.grandTotal,
    required this.discountTotal,
    required this.reports,
  });

  factory CategorySaleResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>?) ?? [];

    return CategorySaleResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      daysCount: _toInt(json['days_count']),
      grandTotal: _toDouble(json['grand_total']),
      discountTotal: _toDouble(json['discount_total']),
      reports: list.map((e) => CategorySaleModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
