import 'dart:convert';

/// 🧾 Individual report item monthly_sales_report
class ReportModel {
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

  ReportModel({
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

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    final price = double.tryParse(json['price'].toString()) ?? 0;
    final purchase = double.tryParse(json['purchase_price'].toString()) ?? 0;

    return ReportModel(
      date: json['date'] ?? '',
      invoiceId: json['invoice_id'] ?? '',
      customerName: json['customer_name'] ?? '',
      productName: json['product_name'] ?? '',
      paymentType: json['payment_type'] ?? '',
      qty: json['qty'] ?? 0,
      price: price,
      purchasePrice: purchase,
      profit: price - purchase,
      orderType: json['order_type'] ?? 0,
      imei: json['imei'],
    );
  }
}

/// 📦 Top-level response monthly_sales_report (includes totals + report list)
class ReportResponse {
  final bool success;
  final String message;
  final int daysCount;
  final double grandTotal;
  final double discountTotal;
  final List<ReportModel> reports;

  ReportResponse({
    required this.success,
    required this.message,
    required this.daysCount,
    required this.grandTotal,
    required this.discountTotal,
    required this.reports,
  });

  factory ReportResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = json['data'] ?? [];

    return ReportResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      daysCount: json['days_count'] ?? 0,
      grandTotal: double.tryParse(json['grand_total'].toString()) ?? 0,
      discountTotal: double.tryParse(json['discount_total'].toString()) ?? 0,
      reports: list.map((e) => ReportModel.fromJson(e)).toList(),
    );
  }
}
