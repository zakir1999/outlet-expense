import 'package:equatable/equatable.dart';

abstract class CashbookDetailsEvent extends Equatable {
  const CashbookDetailsEvent();
  @override
  List<Object?> get props => [];
}

class FetchPaymentTypeOptions extends CashbookDetailsEvent {}

class UpdatePaymentTypeSelection extends CashbookDetailsEvent {
  final int? id;
  final String? name;

  const UpdatePaymentTypeSelection({this.id, this.name});

  @override
  List<Object?> get props => [id, name];
}

class UpdateCashbookDateRange extends CashbookDetailsEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const UpdateCashbookDateRange({this.startDate, this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}

class UpdateOrderType extends CashbookDetailsEvent {
  final String orderType;
  const UpdateOrderType(this.orderType);

  @override
  List<Object?> get props => [orderType];
}

class FetchCashbookDetailsReport extends CashbookDetailsEvent {
  final String startDate;
  final String endDate;
  final int paymentTypeId;
  final String orderType;

  const FetchCashbookDetailsReport({
    required this.startDate,
    required this.endDate,
    required this.paymentTypeId,
    required this.orderType,
  });

  @override
  List<Object?> get props => [startDate, endDate, paymentTypeId, orderType];
}
