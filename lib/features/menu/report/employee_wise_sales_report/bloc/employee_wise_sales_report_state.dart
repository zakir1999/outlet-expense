import 'package:equatable/equatable.dart';

import '../model/employee_wise_sales_report_model.dart';


abstract class EmployeeWiseSalesReportState extends Equatable {
  const EmployeeWiseSalesReportState();

  @override
  List<Object?> get props => [];
}

class EmployeeWiseSalesInitial extends EmployeeWiseSalesReportState {
  const EmployeeWiseSalesInitial();
}

class EmployeeWiseSalesLoading extends EmployeeWiseSalesReportState {
  const EmployeeWiseSalesLoading();
}

class EmployeeWiseSalesLoaded extends EmployeeWiseSalesReportState {
  final List<EmployeeReportItem> data;
  final num grandTotal;


  const EmployeeWiseSalesLoaded({
    required this.data,
    required this.grandTotal,
  });

  @override
  List<Object?> get props => [data, grandTotal];
}

class EmployeeWiseSalesError extends EmployeeWiseSalesReportState {
  final String message;

  const EmployeeWiseSalesError(this.message);

  @override
  List<Object?> get props => [message];
}
