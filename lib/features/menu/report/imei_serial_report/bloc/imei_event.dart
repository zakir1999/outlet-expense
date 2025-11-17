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
//   const ImeiSerialReportUpdateDates({this.startDate, this.endDate});
// }
//
// class ImeiSerialFetchRequested extends ImeiSerialReportEvent {
//   const ImeiSerialFetchRequested();
// }
//
// /// 🆕 Lazy-load dropdown events
// class FetchAllDropdownOptions extends ImeiSerialReportEvent {}
//
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
  const ImeiSerialFetchRequested(

      );
}
class LoadMoreCustomerList extends ImeiSerialReportEvent {}


/// load the first page for all dropdowns (used on init or when you want to fetch
/// the initial page for all: customer, vendor, product, brand)
class FetchAllDropdownOptions extends ImeiSerialReportEvent {
  final int page;
  final int limit;
  const FetchAllDropdownOptions({this.page = 1, this.limit = 10});
}

/// Fetch a single dropdown's page (type: 'customer'|'vendor'|'product'|'brand')
/// append: true -> append to existing list; false -> replace list (useful for search reset)
class FetchDropdownPage extends ImeiSerialReportEvent {
  final String type;
  final int page;
  final int limit;
  final String? search;
  final bool append;

  const FetchDropdownPage({
    required this.type,
    required this.page,
    this.limit = 10,
    this.search,
    this.append = false,
  });
}
