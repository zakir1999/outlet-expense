class EmployeeReportResponse {
  final int status;
  final bool success;
  final String message;
  final List<EmployeeReportItem> data;
  final num grandTotal;

  EmployeeReportResponse({
    required this.status,
    required this.success,
    required this.message,
    required this.data,
    required this.grandTotal,
  });

  factory EmployeeReportResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeReportResponse(
      status: json['status'],
      success: json['success'],
      message: json['message'] ?? "",
      data: (json['data'] as List)
          .map((item) => EmployeeReportItem.fromJson(item))
          .toList(),
      grandTotal: json['grand_total'] ?? 0,
    );
  }
}

class EmployeeReportItem {
  final String date;
  final String invoiceId;
  final String customerName;
  final num paidAmount;
  final String employeeName;
  final String productNames;

  EmployeeReportItem({
    required this.date,
    required this.invoiceId,
    required this.customerName,
    required this.paidAmount,
    required this.employeeName,
    required this.productNames,
  });

  factory EmployeeReportItem.fromJson(Map<String, dynamic> json) {
    return EmployeeReportItem(
      date: json['date'] ?? "",
      invoiceId: json['invoice_id'] ?? "",
      customerName: json['customer_name'] ?? "",
      paidAmount: num.tryParse(json['paid_amount'].toString()) ?? 0,
      employeeName: json['employee_name'] ?? "",
      productNames: json['product_names'] ?? "",
    );
  }
}
class EmployeeItem {
  final int id;
  final String name;

  EmployeeItem({required this.id, required this.name});
}



