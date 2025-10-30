import 'package:equatable/equatable.dart';
import '../sales_model/sales_report_model.dart';

abstract class ReportState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportLoaded extends ReportState {
  final ReportResponse reportResponse;

  ReportLoaded(this.reportResponse);

  @override
  List<Object?> get props => [reportResponse];
}

class ReportError extends ReportState {
  final String message;

  ReportError(this.message);

  @override
  List<Object?> get props => [message];
}
