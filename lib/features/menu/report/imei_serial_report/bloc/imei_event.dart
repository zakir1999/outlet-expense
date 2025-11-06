//
// import 'package:flutter/foundation.dart';
//
// @immutable
// abstract class ImeiSerialReportEvent {
//   const ImeiSerialReportEvent();
// }
//
// class ImeiSerialToggleDateSelection extends ImeiSerialReportEvent {
//   final bool enabled;
//   const ImeiSerialToggleDateSelection(this.enabled);
// }
//
// class ImeiSerialReportUpdateFilters extends ImeiSerialReportEvent {
//   final String brandName;
//   final String productName;
//   final String imei;
//   final String productCondition;
//   final String customerName;
//   final String vendorName;
//   final String stockType;
//
//   const ImeiSerialReportUpdateFilters({
//     this.brandName = '',
//     this.productName = '',
//     this.imei = '',
//     this.productCondition = '',
//     this.customerName = '',
//     this.vendorName = '',
//     this.stockType = '',
//   });
// }
//
// class ImeiSerialReportUpdateDates extends ImeiSerialReportEvent {
//   final DateTime? startDate;
//   final DateTime? endDate;
//
//   const ImeiSerialReportUpdateDates({this.startDate, this.endDate});
// }
//
// class ImeiSerialFetchRequested extends ImeiSerialReportEvent {
//   const ImeiSerialFetchRequested();
// }
// class CustomerOption extends ImeiSerialReportEvent {}
import 'package:flutter/foundation.dart';

@immutable
abstract class ImeiSerialReportEvent {
  const ImeiSerialReportEvent();
}

class ImeiSerialToggleDateSelection extends ImeiSerialReportEvent {
  final bool enabled;
  const ImeiSerialToggleDateSelection(this.enabled);
}

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
}

class ImeiSerialReportUpdateDates extends ImeiSerialReportEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  const ImeiSerialReportUpdateDates({this.startDate, this.endDate});
}

class ImeiSerialFetchRequested extends ImeiSerialReportEvent {
  const ImeiSerialFetchRequested();
}

/// 🆕 Lazy-load dropdown events
class FetchCustomerOptions extends ImeiSerialReportEvent {}
class FetchVendorOptions extends ImeiSerialReportEvent {}
class FetchProductOptions extends ImeiSerialReportEvent {}
class FetchBrandOptions extends ImeiSerialReportEvent {}

