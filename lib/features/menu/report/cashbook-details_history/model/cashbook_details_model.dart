import 'dart:convert';

/// ================= Helper Function =================
double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

/// ================= Transaction Report =================
TransactionReportResponse transactionReportResponseFromJson(String str) =>
    TransactionReportResponse.fromJson(json.decode(str));

class TransactionReportResponse {
  final bool success;
  final String message;
  final List<TransactionItem> data;
  final double openingBalance;
  final double currentTotalCredit;
  final double currentTotalDebit;
  final double closingBalance;

  TransactionReportResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.openingBalance,
    required this.currentTotalCredit,
    required this.currentTotalDebit,
    required this.closingBalance,
  });

  factory TransactionReportResponse.fromJson(Map<String, dynamic> json) =>
      TransactionReportResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? '',
        data: List<TransactionItem>.from(
            (json["data"] as List<dynamic>? ?? [])
                .map((x) => TransactionItem.fromJson(x))),
        openingBalance: _toDouble(json["opening_balance"]),
        currentTotalCredit: _toDouble(json["current_total_credit"]),
        currentTotalDebit: _toDouble(json["current_total_debit"]),
        closingBalance: _toDouble(json["closing_balance"]),
      );
}

class TransactionItem {
  final String date;
  final String status;
  final String type;
  final String invoiceId;
  final double paymentAmount;
  final String? expenseId;
  final String typeName;
  final String? particulars;

  TransactionItem({
    required this.date,
    required this.status,
    required this.type,
    required this.invoiceId,
    required this.paymentAmount,
    required this.expenseId,
    required this.typeName,
    required this.particulars,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) => TransactionItem(
    date: json["date"] ?? '',
    status: json["status"] ?? '',
    type: json["type"] ?? '',
    invoiceId: json["invoice_id"] ?? '',
    paymentAmount: _toDouble(json["payment_amount"]),
    expenseId: json["expense_id"]?.toString(),
    typeName: json["type_name"] ?? '',
    particulars: json["particulars"],
  );
}

/// ================= Payment Type =================
class PaymentTypeItem {
  final int id;
  final String typeName;
  final String iconLetter;
  final String iconImage;
  final List<PaymentCategoryItem> categories;

  PaymentTypeItem({
    required this.id,
    required this.typeName,
    required this.iconLetter,
    required this.iconImage,
    required this.categories,
  });

  factory PaymentTypeItem.fromJson(Map<String, dynamic> json) {
    return PaymentTypeItem(
      id: json['id'] ?? 0,
      typeName: json['type_name'] ?? '',
      iconLetter: json['icon_letter'] ?? '',
      iconImage: json['icon_image'] ?? '',
      categories: (json['payment_type_category'] as List<dynamic>? ?? [])
          .map((c) => PaymentCategoryItem.fromJson(c))
          .toList(),
    );
  }
}

class PaymentCategoryItem {
  final int id;
  final String categoryName;
  final String accountNumber;

  PaymentCategoryItem({
    required this.id,
    required this.categoryName,
    required this.accountNumber,
  });

  factory PaymentCategoryItem.fromJson(Map<String, dynamic> json) {
    return PaymentCategoryItem(
      id: json['id'] ?? 0,
      categoryName: json['payment_category_name'] ?? '',
      accountNumber: json['account_number'] ?? '',
    );
  }
}
