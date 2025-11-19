import 'package:equatable/equatable.dart';

abstract class CustomerSummaryReportEvent extends Equatable {
  const CustomerSummaryReportEvent();

  @override
  List<Object?> get props => [];
}

class FetchCustomerSummaryReportEvent extends CustomerSummaryReportEvent {
  final String startDate;
  final String endDate;
  final int id;

  const FetchCustomerSummaryReportEvent({
    required this.startDate,
    required this.endDate,
    required this.id,
  });

  @override
  List<Object?> get props => [startDate, endDate, id];
}

/// Fetch employee list
class FetchCustomerOptions extends CustomerSummaryReportEvent {}

/// Dropdown selection change
class UpdateCustomerName extends CustomerSummaryReportEvent {
  final int? id;
  final String? customerName;

  const UpdateCustomerName({this.id,this.customerName});

  @override
  List<Object?> get props => [customerName,id];
}

/// Date changes
class CustomerWiseUpdateDates extends CustomerSummaryReportEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const CustomerWiseUpdateDates({this.startDate, this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}
