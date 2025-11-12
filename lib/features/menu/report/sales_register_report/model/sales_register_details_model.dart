import 'dart:convert';

class SalesRegisterDetailsModel {
  final int status;
  final bool success;
  final String message;
  final List<SalesData> data;
  final int totalDiscountAmount;
  final int totalSalesAmount;

  SalesRegisterDetailsModel({
    required this.status,
    required this.success,
    required this.message,
    required this.data,
    required this.totalDiscountAmount,
    required this.totalSalesAmount,
  });

  /// Factory constructor to create an instance from JSON Map
  factory SalesRegisterDetailsModel.fromJson(Map<String, dynamic> json) {
    return SalesRegisterDetailsModel(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SalesData.fromJson(e))
          .toList() ??
          [],
      totalDiscountAmount: json['total_discount_amount'] ?? 0,
      totalSalesAmount: json['total_sales_amount'] ?? 0,
    );
  }

  /// Converts monthly_sales_report to JSON Map
  Map<String, dynamic> toJson() => {
    'status': status,
    'success': success,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
    'total_discount_amount': totalDiscountAmount,
    'total_sales_amount': totalSalesAmount,
  };

  /// Parse from raw JSON string
  static SalesRegisterDetailsModel fromRawJson(String str) =>
      SalesRegisterDetailsModel.fromJson(json.decode(str));

  /// Convert to raw JSON string
  String toRawJson() => json.encode(toJson());
}

class SalesData {
  final String date;
  final int salesDiscount;
  final int salesAmount;
  final int slImei; // kept as slImei for backend consistency
  final int normal;
  final int gift;
  final int giftAmount;

  SalesData({
    required this.date,
    required this.salesDiscount,
    required this.salesAmount,
    required this.slImei,
    required this.normal,
    required this.gift,
    required this.giftAmount,
  });

  /// Factory constructor to create an instance from JSON Map
  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      date: json['date'] ?? '',
      salesDiscount: json['sales_discount'] ?? 0,
      salesAmount: json['sales_amount'] ?? 0,
      slImei: json['sl_imei'] ?? 0,
      normal: json['normal'] ?? 0,
      gift: json['gift'] ?? 0,
      giftAmount: json['gift_amount'] ?? 0,
    );
  }

  /// Converts monthly_sales_report to JSON Map
  Map<String, dynamic> toJson() => {
    'date': date,
    'sales_discount': salesDiscount,
    'sales_amount': salesAmount,
    'sl_imei': slImei,
    'normal': normal,
    'gift': gift,
    'gift_amount': giftAmount,
  };
}
