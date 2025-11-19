// class CustomerSummaryReportResponse {
//   final int status;
//   final bool success;
//   final String message;
//   final List<CustomerSummaryReportItem> data;
//   final num grandTotal;
//
//   CustomerSummaryReportResponse({
//     required this.status,
//     required this.success,
//     required this.message,
//     required this.data,
//     required this.grandTotal,
//   });
//
//   factory CustomerSummaryReportResponse.fromJson(Map<String, dynamic> json) {
//     return CustomerSummaryReportResponse(
//       status: json['status'],
//       success: json['success'],
//       message: json['message'] ?? "",
//       data: (json['data'] as List)
//           .map((item) => CustomerSummaryReportItem.fromJson(item))
//           .toList(),
//       grandTotal: json['grand_total'] ?? 0,
//     );
//   }
// }
//
// class CustomerSummaryReportItem {
//   final String date;
//   final String invoiceId;
//   final String customerName;
//   final num paidAmount;
//   final String employeeName;
//   final String productNames;
//
//   CustomerSummaryReportItem({
//     required this.date,
//     required this.invoiceId,
//     required this.customerName,
//     required this.paidAmount,
//     required this.employeeName,
//     required this.productNames,
//   });
//
//   factory CustomerSummaryReportItem.fromJson(Map<String, dynamic> json) {
//     return CustomerSummaryReportItem(
//       date: json['date'] ?? "",
//       invoiceId: json['invoice_id'] ?? "",
//       customerName: json['customer_name'] ?? "",
//       paidAmount: num.tryParse(json['paid_amount'].toString()) ?? 0,
//       employeeName: json['employee_name'] ?? "",
//       productNames: json['product_names'] ?? "",
//     );
//   }
// }


class CustomerSummaryReportResponse {
  final int status;
  final bool success;
  final String message;
  final CustomerData data;
  final num grandNetTotal;
  final num grandNetTotalQuantity;
  final List<SalesDetail> salesDetails;


  CustomerSummaryReportResponse({
    required this.salesDetails,
    required this.status,
    required this.success,
    required this.message,
    required this.data,
    required this.grandNetTotal,
    required this.grandNetTotalQuantity,
  });

  factory CustomerSummaryReportResponse.fromJson(Map<String, dynamic> json) {
    return CustomerSummaryReportResponse(
      status: json['status'],
      success: json['success'],
      message: json['message'] ?? "",
      data: CustomerData.fromJson(json['data']),
      grandNetTotal: json['grand_net_total'] ?? 0,
      grandNetTotalQuantity: json['grand_net_total_quantity'] ?? 0,
      salesDetails: (json['sales_details'] as List)
          .map((e) => SalesDetail.fromJson(e))
          .toList(),

    );

  }
  int get totalQty =>
      salesDetails.fold(0, (sum, item) => sum + item.qty.toInt());
}

class CustomerData {
  final int id;
  final String name;
  final List<InvoiceItem> invoiceList;

  CustomerData({
    required this.id,
    required this.name,
    required this.invoiceList,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      id: json['id'],
      name: json['name'] ?? "",
      invoiceList: (json['invoice_list'] as List)
          .map((e) => InvoiceItem.fromJson(e))
          .toList(),
    );
  }
}

class InvoiceItem {
  final String invoiceId;
  final num subTotal;
  final num paidAmount;
  final String createdAt;
  final List<SalesDetail> salesDetails;

  InvoiceItem({
    required this.invoiceId,
    required this.subTotal,
    required this.paidAmount,
    required this.createdAt,
    required this.salesDetails,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      invoiceId: json['invoice_id'] ?? "",
      subTotal: json['sub_total'] ?? 0,
      paidAmount: json['paid_amount'] ?? 0,
      createdAt: json['created_at'] ?? "",
      salesDetails: (json['sales_details'] as List)
          .map((e) => SalesDetail.fromJson(e))
          .toList(),
    );
  }
}

class SalesDetail {
  final num qty;

  SalesDetail({
    required this.qty,
  });

  factory SalesDetail.fromJson(Map<String, dynamic> json) {
    return SalesDetail(
      qty: json['qty'] ?? 0,
    );
  }
}
class CustomerItem {
  final int id;
  final String name;

  CustomerItem({required this.id, required this.name});
}



