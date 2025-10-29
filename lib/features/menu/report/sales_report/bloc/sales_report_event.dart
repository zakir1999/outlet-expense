import 'package:equatable/equatable.dart';

abstract class ReportEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchReportEvent extends ReportEvent {
  final String startDate;
  final String endDate;
  final String filter;
  final String brandId;

  FetchReportEvent({
    required this.startDate,
    required this.endDate,
    required this.filter,
    required this.brandId,
  });

  @override
  List<Object?> get props => [startDate, endDate, filter, brandId];
}
