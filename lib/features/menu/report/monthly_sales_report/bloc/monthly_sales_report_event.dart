import 'package:equatable/equatable.dart';

abstract class MonthlySalesReportEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMonthlySaleEvent extends MonthlySalesReportEvent {
  final String startDate;
  final String endDate;
  final String filter;
  final String brandId;

  FetchMonthlySaleEvent({
    required this.startDate,
    required this.endDate,
    required this.filter,
    required this.brandId,
  });

  @override
  List<Object?> get props => [startDate, endDate, filter, brandId];
}
