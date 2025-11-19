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
  final List<EmployeeItem> employeeOptions;
  final String? employeeName;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? id;
  final num grandTotal;
  final int employeePage;
  final bool hasMoreEmployee;
  final bool loadingEmployee;

  const EmployeeWiseSalesLoaded( {
    this.id,
    required this.data,
    required this.employeeOptions,
    this.employeeName,
    this.startDate,
    this.endDate,
    required this.grandTotal,
    required this.employeePage,
    required this.hasMoreEmployee,
    required this.loadingEmployee,
  });

  EmployeeWiseSalesLoaded copyWith({
    List<EmployeeReportItem>? data,
    List<EmployeeItem>? employeeOptions,
    String? employeeName,
    int? id,
    DateTime? startDate,
    DateTime? endDate,
    num? grandTotal,
    int? employeePage,
    bool? hasMoreEmployee,
    bool? loadingEmployee,
  }) {
    return EmployeeWiseSalesLoaded(
      data: data ?? this.data,
      employeeOptions: employeeOptions ?? this.employeeOptions,
      employeeName: employeeName ?? this.employeeName,
      startDate: startDate ?? this.startDate,
      id:id??this.id,
      endDate: endDate ?? this.endDate,
      grandTotal: grandTotal ?? this.grandTotal,
      employeePage: employeePage ?? this.employeePage,
      hasMoreEmployee: hasMoreEmployee ?? this.hasMoreEmployee,
      loadingEmployee: loadingEmployee ?? this.loadingEmployee,
    );
  }

  @override
  List<Object?> get props => [
    data,
    employeeOptions,
    employeeName,
    startDate,
    id,
    endDate,
    grandTotal,
    employeePage,
    hasMoreEmployee,
    loadingEmployee,
  ];
}

class EmployeeWiseSalesError extends EmployeeWiseSalesReportState {
  final String message;

  const EmployeeWiseSalesError(this.message);

  @override
  List<Object?> get props => [message];
}