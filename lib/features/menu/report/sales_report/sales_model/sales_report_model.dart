class ReportModel {
  final String date;
  final String invoiceId;
  final String customerName;
  final String productName;
  final String paymentType;
  final int qty;
  final double salesAmount;
  final double purchaseAmount;
  final double profit;
  final int orderType; // 1=Sale,2=Warranty,... adjust if needed
  final String? imei;

  ReportModel({
    required this.date,
    required this.invoiceId,
    required this.customerName,
    required this.productName,
    required this.paymentType,
    required this.qty,
    required this.salesAmount,
    required this.purchaseAmount,
    required this.profit,
    required this.orderType,
    this.imei,
  });

  String get orderTypeName => orderType == 1 ? "Sale" : "Other";

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      date: json['date'],
      invoiceId: json['invoice_id'],
      customerName: json['customer_name'],
      productName: json['product_name'],
      paymentType: json['payment_type'],
      qty: json['qty'] ?? 0,
      salesAmount: double.tryParse(json['price'].toString()) ?? 0,
      purchaseAmount: double.tryParse(json['purchase_price'].toString()) ?? 0,
      profit: (double.tryParse(json['price'].toString()) ?? 0) -
          (double.tryParse(json['purchase_price'].toString()) ?? 0),
      orderType: json['order_type'] ?? 0,
      imei: json['imei'],
    );
  }
}
