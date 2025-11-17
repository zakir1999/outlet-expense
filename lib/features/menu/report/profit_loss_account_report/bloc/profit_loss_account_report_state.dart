
import 'package:equatable/equatable.dart';

import '../model/profit_loss_account_report_model.dart';

abstract class ProfitLossReportState extends Equatable {
  const ProfitLossReportState();

  @override
  List<Object?> get props => [];
}

class ProfitLossReportInitial extends ProfitLossReportState {}

class ProfitLossReportLoading extends ProfitLossReportState {}

class ProfitLossReportLoaded extends ProfitLossReportState {
  final ProfitLossReport report;

  const ProfitLossReportLoaded({required this.report});

  @override
  List<Object?> get props => [report];
}

class ProfitLossReportError extends ProfitLossReportState {
  final String message;

  const ProfitLossReportError(this.message);

  @override
  List<Object?> get props => [message];
}