
import 'package:flutter/foundation.dart';

import '../model/imei_model.dart';


@immutable
abstract class ImeiSerialReportState {
  const ImeiSerialReportState();
}

class ImeiSerialInitial extends ImeiSerialReportState {}

class ImeiSerialLoading extends ImeiSerialReportState {}


class ImeiSerialLoadSuccess extends ImeiSerialReportState {
  final Map<String, List<ImeiSerialRecord>> groupedRecords;
  final bool dateSelectionEnabled;
  final DateTime? startDate;
  final DateTime? endDate;
  final String brandName;
  final String productName;
  final String imei;
  final String productCondition;
  final String customerName;
  final String vendorName;
  final String stockType;
  final List<String> customerOptions;


  const ImeiSerialLoadSuccess({
    required this.groupedRecords,
    required this.dateSelectionEnabled,
    this.startDate,
    this.endDate,
    this.brandName = '',
    this.productName = '',
    this.imei = '',
    this.productCondition = '',
    this.customerName = '',
    this.vendorName = '',
    this.stockType = '',
    this.customerOptions = const [],

  });

  ImeiSerialLoadSuccess copyWith({
    Map<String, List<ImeiSerialRecord>>? groupedRecords,
    bool? dateSelectionEnabled,
    DateTime? startDate,
    DateTime? endDate,
    String? brandName,
    String? productName,
    String? imei,
    String? productCondition,
    String? customerName,
    String? vendorName,
    String? stockType,
    List<String>? customerOptions,

  }) {
    return ImeiSerialLoadSuccess(
      groupedRecords: groupedRecords ?? this.groupedRecords,
      dateSelectionEnabled: dateSelectionEnabled ?? this.dateSelectionEnabled,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      brandName: brandName ?? this.brandName,
      productName: productName ?? this.productName,
      imei: imei ?? this.imei,
      productCondition: productCondition ?? this.productCondition,
      customerName: customerName ?? this.customerName,
      vendorName: vendorName ?? this.vendorName,
      stockType: stockType ?? this.stockType,
      customerOptions: customerOptions ?? this.customerOptions,

    );
  }
  @override
  List<Object?> get props => [
    groupedRecords,
    dateSelectionEnabled,
    startDate,
    endDate,
    brandName,
    productName,
    imei,
    productCondition,
    customerName,
    vendorName,
    stockType,
    customerOptions,
  ];
}

class ImeiSerialLoadFailure extends ImeiSerialReportState {
  final String error;
  const ImeiSerialLoadFailure(this.error);
}
