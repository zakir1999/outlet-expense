import 'package:equatable/equatable.dart';
abstract class PurchaseRegisterDetailsEvent extends Equatable {
  const PurchaseRegisterDetailsEvent();

  @override
  List<Object?> get props => [];
}

class FetchPurchaseRegisterDetailsEvent extends PurchaseRegisterDetailsEvent {
  final String startDate;
  final String endDate;

  const FetchPurchaseRegisterDetailsEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}
