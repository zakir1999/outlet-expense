import 'package:equatable/equatable.dart';

class DueReportModel extends Equatable {
  final int status;
  final bool success;
  final String message;
  final List<DueReportData> data;
  final num totalDue;

  const DueReportModel({
    required this.status,
    required this.success,
    required this.message,
    required this.data,
    required this.totalDue,
  });

  factory DueReportModel.fromJson(Map<String, dynamic> json) {
    return DueReportModel(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => DueReportData.fromJson(e))
          .toList() ??
          [],
      totalDue: json['total_due'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
      'total_due': totalDue,
    };
  }

  DueReportModel copyWith({
    int? status,
    bool? success,
    String? message,
    List<DueReportData>? data,
    num? totalDue,
  }) {
    return DueReportModel(
      status: status ?? this.status,
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
      totalDue: totalDue ?? this.totalDue,
    );
  }

  @override
  List<Object?> get props => [status, success, message, data, totalDue];
}

class DueReportData extends Equatable {
  final int id;
  final String invoiceId;
  final String name;
  final num paidAmount;
  final num totalAmount;
  final num due;

  const DueReportData({
    required this.id,
    required this.invoiceId,
    required this.name,
    required this.paidAmount,
    required this.totalAmount,
    required this.due,
  });

  factory DueReportData.fromJson(Map<String, dynamic> json) {
    return DueReportData(
      id: json['id'] ?? 0,
      invoiceId: json['invoice_id'] ?? '',
      name: json['name'] ?? '',
      paidAmount: json['paid_amount'] ?? 0,
      totalAmount: json['total_amount'] ?? 0,
      due: json['due'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_id': invoiceId,
      'name': name,
      'paid_amount': paidAmount,
      'total_amount': totalAmount,
      'due': due,
    };
  }

  DueReportData copyWith({
    int? id,
    String? invoiceId,
    String? name,
    num? paidAmount,
    num? totalAmount,
    num? due,
  }) {
    return DueReportData(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      name: name ?? this.name,
      paidAmount: paidAmount ?? this.paidAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      due: due ?? this.due,
    );
  }

  @override
  List<Object?> get props => [id, invoiceId, name, paidAmount, totalAmount, due];
}
