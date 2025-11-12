class MonthlySalesModel {
  final bool success;
  final String message;
  final List<MonthlySaleData> data;
  final int daysCount;
  final double grandTotal;
  final double discountTotal;

  MonthlySalesModel({
    required this.success,
    required this.message,
    required this.data,
    required this.daysCount,
    required this.grandTotal,
    required this.discountTotal,
  });

  factory MonthlySalesModel.fromJson(Map<String, dynamic> json) {
    return MonthlySalesModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] == null
          ? []
          : List<MonthlySaleData>.from(
        json['data'].map((x) => MonthlySaleData.fromJson(x)),
      ),
      daysCount: json['days_count'] ?? 0,

      /// ✅ Convert both INT or STRING to DOUBLE safely
      grandTotal: double.tryParse(json['grand_total'].toString()) ?? 0,
      discountTotal: double.tryParse(json['discount_total'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
      'days_count': daysCount,
      'grand_total': grandTotal,
      'discount_total': discountTotal,
    };
  }
}

class MonthlySaleData {
  final String date;
  final String invoiceId;
  final String customerName;
  final int orderType;
  final String productName;
  final String paymentType;
  final int qty;
  final double price;
  final double purchasePrice;
  final double profit;
  final String imei;

  MonthlySaleData({
    required this.date,
    required this.invoiceId,
    required this.customerName,
    required this.orderType,
    required this.productName,
    required this.paymentType,
    required this.qty,
    required this.price,
    required this.purchasePrice,
    required this.profit,
    required this.imei,
  });

  factory MonthlySaleData.fromJson(Map<String, dynamic> json) {
    final price = double.tryParse(json['price'].toString()) ?? 0;
    final purchase = double.tryParse(json['purchase_price'].toString()) ?? 0;

    return MonthlySaleData(
      date: json['date'] ?? '',
      invoiceId: json['invoice_id'] ?? '',
      customerName: json['customer_name'] ?? '',
      orderType: json['order_type'] ?? 0,
      productName: json['product_name'] ?? '',
      paymentType: json['payment_type'] ?? '',
      qty: json['qty'] ?? 0,
      price: price,
      purchasePrice: purchase,
      profit: price - purchase,
      imei: json['imei'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'invoice_id': invoiceId,
      'customer_name': customerName,
      'order_type': orderType,
      'product_name': productName,
      'payment_type': paymentType,
      'qty': qty,
      'price': price,
      'purchase_price': purchasePrice,
      'profit': profit,
      'imei': imei,
    };
  }
}
