// import 'package:equatable/equatable.dart';
//
// import '../model/customer_summary_report_model.dart';
//
//
// abstract class CustomerSummaryReportState extends Equatable {
//   const CustomerSummaryReportState();
//
//   @override
//   List<Object?> get props => [];
// }
//
// class CustomerSummaryInitial extends CustomerSummaryReportState {
//   const CustomerSummaryInitial();
// }
//
// class CustomerSummaryLoading extends CustomerSummaryReportState {
//   const CustomerSummaryLoading();
// }
//
// class CustomerSummaryLoaded extends CustomerSummaryReportState {
//   final List<CustomerSummaryReportItem> data;
//   final List<CustomerItem> customerOptions;
//   final String? customerName;
//   final DateTime? startDate;
//   final DateTime? endDate;
//   final int? id;
//   final num grandTotal;
//   final int customerPage;
//   final bool hasMoreCustomer;
//   final bool loadingCustomer;
//
//   const CustomerSummaryLoaded( {
//     this.id,
//     required this.data,
//     required this.customerOptions,
//     this.customerName,
//     this.startDate,
//     this.endDate,
//     required this.grandTotal,
//     required this.customerPage,
//     required this.hasMoreCustomer,
//     required this.loadingCustomer,
//   });
//
//   CustomerSummaryLoaded copyWith({
//     List<CustomerSummaryReportItem>? data,
//     List<CustomerItem>? customerOptions,
//     String? customerName,
//     int? id,
//     DateTime? startDate,
//     DateTime? endDate,
//     num? grandTotal,
//     int? customerPage,
//     bool? hasMoreCustomer,
//     bool? loadingCustomer,
//   }) {
//     return CustomerSummaryLoaded(
//       data: data ?? this.data,
//       customerOptions: customerOptions ?? this.customerOptions,
//       customerName: customerName ?? this.customerName,
//       startDate: startDate ?? this.startDate,
//       id:id??this.id,
//       endDate: endDate ?? this.endDate,
//       grandTotal: grandTotal ?? this.grandTotal,
//       customerPage: customerPage ?? this.customerPage,
//       hasMoreCustomer: hasMoreCustomer ?? this.hasMoreCustomer,
//       loadingCustomer: loadingCustomer ?? this.loadingCustomer,
//     );
//   }
//
//   @override
//   List<Object?> get props => [
//     data,
//     customerOptions,
//     customerName,
//     startDate,
//     id,
//     endDate,
//     grandTotal,
//     customerPage,
//     hasMoreCustomer,
//     loadingCustomer,
//   ];
// }
//
// class CustomerSummaryError extends CustomerSummaryReportState {
//   final String message;
//
//   const CustomerSummaryError(this.message);
//
//   @override
//   List<Object?> get props => [message];
// }
import 'package:equatable/equatable.dart';

import '../model/customer_summary_report_model.dart';

abstract class CustomerSummaryReportState extends Equatable {
  const CustomerSummaryReportState();

  @override
  List<Object?> get props => [];
}

class CustomerSummaryInitial extends CustomerSummaryReportState {
  const CustomerSummaryInitial();
}

class CustomerSummaryLoading extends CustomerSummaryReportState {
  const CustomerSummaryLoading();
}

class CustomerSummaryLoaded extends CustomerSummaryReportState {
  final List<InvoiceItem> data;                          // UPDATED
  final List<CustomerItem> customerOptions;
  final String? customerName;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? id;
  final num grandTotal;                                  // UPDATED (maps API grand_net_total)
  final int customerPage;
  final bool hasMoreCustomer;
  final bool loadingCustomer;

  const CustomerSummaryLoaded({
    this.id,
    required this.data,
    required this.customerOptions,
    this.customerName,
    this.startDate,
    this.endDate,
    required this.grandTotal,
    required this.customerPage,
    required this.hasMoreCustomer,
    required this.loadingCustomer,
  });

  CustomerSummaryLoaded copyWith({
    List<InvoiceItem>? data,                              // UPDATED
    List<CustomerItem>? customerOptions,
    String? customerName,
    int? id,
    DateTime? startDate,
    DateTime? endDate,
    num? grandTotal,
    int? customerPage,
    bool? hasMoreCustomer,
    bool? loadingCustomer,
  }) {
    return CustomerSummaryLoaded(
      data: data ?? this.data,
      customerOptions: customerOptions ?? this.customerOptions,
      customerName: customerName ?? this.customerName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      id: id ?? this.id,
      grandTotal: grandTotal ?? this.grandTotal,
      customerPage: customerPage ?? this.customerPage,
      hasMoreCustomer: hasMoreCustomer ?? this.hasMoreCustomer,
      loadingCustomer: loadingCustomer ?? this.loadingCustomer,
    );
  }

  @override
  List<Object?> get props => [
    data,
    customerOptions,
    customerName,
    startDate,
    endDate,
    id,
    grandTotal,
    customerPage,
    hasMoreCustomer,
    loadingCustomer,
  ];
}

class CustomerSummaryError extends CustomerSummaryReportState {
  final String message;

  const CustomerSummaryError(this.message);

  @override
  List<Object?> get props => [message];
}
