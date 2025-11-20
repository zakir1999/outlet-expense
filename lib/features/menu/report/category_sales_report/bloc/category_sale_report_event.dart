import 'package:equatable/equatable.dart';

abstract class CategorySaleReportEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchCategorySaleEvent extends CategorySaleReportEvent {
  final String startDate;
  final String endDate;
  final String filter;
  final String brandId;

  final bool forceRefresh;


  FetchCategorySaleEvent({
    required this.startDate,
    required this.endDate,
    required this.filter,
    required this.brandId,
    this.forceRefresh=false,
  });

  @override
  List<Object?> get props => [startDate, endDate, filter, brandId,forceRefresh];
}
