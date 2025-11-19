// cashbook_details_history_state.dart
import 'package:equatable/equatable.dart';

import '../model/cashbook_details_model.dart';

class CashbookDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CashbookDetailsInitial extends CashbookDetailsState {}

class CashbookDetailsLoading extends CashbookDetailsState {}

class CashbookDetailsError extends CashbookDetailsState {
  final String message;
  CashbookDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

class CashbookDetailsLoaded extends CashbookDetailsState {
  final List<TransactionItem> data;
  final List<PaymentTypeItem> paymentTypes;
  final String? paymentTypeName;
  final int? paymentTypeId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String orderType;
  final num totalAmount;

  final double openingBalance;
  final double currentTotalCredit;
  final double currentTotalDebit;
  final double closingBalance;

  CashbookDetailsLoaded({
    required this.data,
    required this.paymentTypes,
    this.paymentTypeName,
    this.paymentTypeId,
    this.startDate,
    this.endDate,
    required this.orderType,
    required this.totalAmount,
    required this.openingBalance,
    required this.currentTotalCredit,
    required this.currentTotalDebit,
    required this.closingBalance,
  });

  CashbookDetailsLoaded copyWith({
    List<TransactionItem>? data,
    List<PaymentTypeItem>? paymentTypes,
    String? paymentTypeName,
    int? paymentTypeId,
    DateTime? startDate,
    DateTime? endDate,
    String? orderType,
    num? totalAmount,
    double? openingBalance,
    double? currentTotalCredit,
    double? currentTotalDebit,
    double? closingBalance,
  }) {
    return CashbookDetailsLoaded(
      data: data ?? this.data,
      paymentTypes: paymentTypes ?? this.paymentTypes,
      paymentTypeName: paymentTypeName ?? this.paymentTypeName,
      paymentTypeId: paymentTypeId ?? this.paymentTypeId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      orderType: orderType ?? this.orderType,
      totalAmount: totalAmount ?? this.totalAmount,
      openingBalance: openingBalance ?? this.openingBalance,
      currentTotalCredit: currentTotalCredit ?? this.currentTotalCredit,
      currentTotalDebit: currentTotalDebit ?? this.currentTotalDebit,
      closingBalance: closingBalance ?? this.closingBalance,
    );
  }

  @override
  List<Object?> get props => [
    data,
    paymentTypes,
    paymentTypeName,
    paymentTypeId,
    startDate,
    endDate,
    orderType,
    totalAmount,
    openingBalance,
    currentTotalCredit,
    currentTotalDebit,
    closingBalance,
  ];
}
