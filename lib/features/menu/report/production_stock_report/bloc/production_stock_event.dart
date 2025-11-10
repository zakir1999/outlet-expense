import 'package:equatable/equatable.dart';



abstract class ProductionStockEvent extends Equatable {
  const ProductionStockEvent();

  @override
  List<Object?> get props => [];
}

class FetchProductionStockEvent extends ProductionStockEvent {
  final String startDate;
  final String endDate;

  const FetchProductionStockEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}
