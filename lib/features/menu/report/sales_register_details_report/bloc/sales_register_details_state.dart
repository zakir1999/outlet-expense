
import 'package:equatable/equatable.dart';

abstract class SalesRegisterDetailsEvent extends Equatable {
  const SalesRegisterDetailsEvent();

  @override
  List<Object?> get props => [];
}

class FetchSalesRegisterDetailsEvent extends SalesRegisterDetailsEvent {
  final String startDate;
  final String endDate;

  const FetchSalesRegisterDetailsEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}