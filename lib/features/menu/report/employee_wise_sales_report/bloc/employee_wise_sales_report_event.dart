import 'package:equatable/equatable.dart';

abstract class EmployeeWiseSalesReportEvent extends Equatable {
  const EmployeeWiseSalesReportEvent();

  @override
  List<Object?> get props => [];
}

/// MAIN EVENT: fetch report
class FetchEmployeeWiseSalesReportEvent extends EmployeeWiseSalesReportEvent {
  final String startDate;
  final String endDate;
  final int id;

  const FetchEmployeeWiseSalesReportEvent({
    required this.startDate,
    required this.endDate,
    required this.id,
  });

  @override
  List<Object?> get props => [startDate, endDate, id];
}

/// Fetch employee list
class FetchEmployeeOptions extends EmployeeWiseSalesReportEvent {}

/// Dropdown selection change
class UpdateEmployeeName extends EmployeeWiseSalesReportEvent {
  final int? id;
  final String? employeeName;

  const UpdateEmployeeName({this.id,this.employeeName});

  @override
  List<Object?> get props => [employeeName,id];
}

/// Date changes
class EmployeeWiseUpdateDates extends EmployeeWiseSalesReportEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const EmployeeWiseUpdateDates({this.startDate, this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}
