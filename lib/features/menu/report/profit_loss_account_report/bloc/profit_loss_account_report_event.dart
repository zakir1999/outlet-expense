
import 'package:equatable/equatable.dart';

abstract class ProfitLossReportEvent extends Equatable {
  const ProfitLossReportEvent();

  @override
  List<Object?> get props => [];
}

class FetchProfitLossReportEvent extends ProfitLossReportEvent {
  final String startDate;
  final String endDate;
  final bool forceRefresh;

  const FetchProfitLossReportEvent({
    required this.startDate,
    required this.endDate,
    this.forceRefresh=false,
  });

  @override
  List<Object?> get props => [startDate, endDate,forceRefresh];
}