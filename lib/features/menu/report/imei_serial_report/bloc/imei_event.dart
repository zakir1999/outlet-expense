import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class ImeiSerialReportEvent extends Equatable {
  const ImeiSerialReportEvent();

  @override
  List<Object?> get props => [];
}

// Fetch initial dropdown data
class FetchAllDropdownOptions extends ImeiSerialReportEvent {}

// Pagination
class FetchDropdownPage extends ImeiSerialReportEvent {
  final String type; // customer/vendor/product/brand
  final int page;
  final int limit;
  final bool append;

  const FetchDropdownPage({
    required this.type,
    required this.page,
    required this.limit,
    this.append = false,
  });

  @override
  List<Object?> get props => [type, page, limit, append];
}

// Update Filters
class ImeiSerialReportUpdateFilters extends ImeiSerialReportEvent {
  final String brandName;
  final String productName;
  final String imei;
  final String productCondition;
  final String customerName;
  final String vendorName;
  final String stockType;

  const ImeiSerialReportUpdateFilters({
    this.brandName = '',
    this.productName = '',
    this.imei = '',
    this.productCondition = '',
    this.customerName = '',
    this.vendorName = '',
    this.stockType = '',
  });

  @override
  List<Object?> get props => [
    brandName,
    productName,
    imei,
    productCondition,
    customerName,
    vendorName,
    stockType,
  ];
}

// Update selected customer/vendor/product/brand
class UpdateCustomerName extends ImeiSerialReportEvent {
  final String customerName;
  const UpdateCustomerName(this.customerName);

  @override
  List<Object?> get props => [customerName];
}

class UpdateVendorName extends ImeiSerialReportEvent {
  final String vendorName;
  const UpdateVendorName(this.vendorName);

  @override
  List<Object?> get props => [vendorName];
}

class UpdateProductName extends ImeiSerialReportEvent {
  final String productName;
  const UpdateProductName(this.productName);

  @override
  List<Object?> get props => [productName];
}

class UpdateBrandName extends ImeiSerialReportEvent {
  final String brandName;
  const UpdateBrandName(this.brandName);

  @override
  List<Object?> get props => [brandName];
}

// Toggle date selection
class ImeiSerialToggleDateSelection extends ImeiSerialReportEvent {
  final bool enabled;
  const ImeiSerialToggleDateSelection(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

// Fetch IMEI/Serial report
class ImeiSerialFetchRequested extends ImeiSerialReportEvent {}
class ImeiSerialReportUpdateDates extends ImeiSerialReportEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const ImeiSerialReportUpdateDates({this.startDate, this.endDate});
  @override
  List<Object?> get props => [startDate, endDate];
}
