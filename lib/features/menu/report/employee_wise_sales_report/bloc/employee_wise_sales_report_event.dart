import 'package:equatable/equatable.dart';

abstract class EmployeeWiseSalesReportEvent extends Equatable {
  const EmployeeWiseSalesReportEvent();

  @override
  List<Object?> get props => [];
}

class FetchEmployeeWiseSalesReportEvent extends EmployeeWiseSalesReportEvent {
  final String startDate;
  final String endDate;
  final String id;

  const FetchEmployeeWiseSalesReportEvent({
    required this.startDate,
    required this.endDate,
    required this.id,
  });

  @override
  List<Object?> get props => [startDate, endDate,id];
}
