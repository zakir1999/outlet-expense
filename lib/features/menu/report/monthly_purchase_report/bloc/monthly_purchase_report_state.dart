import 'package:equatable/equatable.dart';
import '../model/monthly_purchase_report_model.dart';

abstract class MonthlyPurchaseState extends Equatable {
  const MonthlyPurchaseState();

  @override
  List<Object?> get props => [];
}

class MonthlyPurchaseInitial extends MonthlyPurchaseState {
  const MonthlyPurchaseInitial();
}

class MonthlyPurchaseLoading extends MonthlyPurchaseState {
  const MonthlyPurchaseLoading();
}

class MonthlyPurchaseLoaded extends MonthlyPurchaseState {
  final List<MonthlyPurchaseItem> data;
  final int daysCount;
  final double grandTotal;

  const MonthlyPurchaseLoaded({
    required this.data,
    required this.daysCount,
    required this.grandTotal,
  });

  @override
  List<Object?> get props => [data, daysCount, grandTotal];
}

class MonthlyPurchaseError extends MonthlyPurchaseState {
  final String message;

  const MonthlyPurchaseError(this.message);

  @override
  List<Object?> get props => [message];
}
