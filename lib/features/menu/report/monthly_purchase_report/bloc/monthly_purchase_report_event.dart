import 'package:equatable/equatable.dart';

abstract class MonthlyPurchaseEvent extends Equatable {
  const MonthlyPurchaseEvent();

  @override
  List<Object?> get props => [];
}

class FetchMonthlyPurchaseEvent extends MonthlyPurchaseEvent {
  final String startDate;
  final String endDate;

  const FetchMonthlyPurchaseEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}
