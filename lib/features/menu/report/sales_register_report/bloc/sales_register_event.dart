import 'package:equatable/equatable.dart';

abstract class SalesRegisterEvent extends Equatable {
  const SalesRegisterEvent();

  @override
  List<Object?> get props => [];
}

class FetchSalesRegister extends SalesRegisterEvent {
  final String startDate;
  final String endDate;
  final bool forceRefresh;

  const FetchSalesRegister({
    this.forceRefresh=false,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate,forceRefresh];
}
