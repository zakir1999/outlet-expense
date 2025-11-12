import 'package:equatable/equatable.dart';

import '../model/monthly_sales_model.dart';

abstract class MonthlySalesReportState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MonthlySaleInitial extends MonthlySalesReportState {}

class MonthlySaleLoading extends MonthlySalesReportState {}

class MonthlySaleLoaded extends MonthlySalesReportState {
  final MonthlySalesModel reportResponse;

  MonthlySaleLoaded(this.reportResponse);

  @override
  List<Object?> get props => [reportResponse];
}

class MonthlySaleError extends MonthlySalesReportState {
  final String message;

  MonthlySaleError(this.message);

  @override
  List<Object?> get props => [message];
}
