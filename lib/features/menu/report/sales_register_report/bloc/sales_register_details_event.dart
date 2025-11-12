// lib/features/reports/sales_register/bloc/sales_register_details_event.dart
import 'package:equatable/equatable.dart';

abstract class SalesRegisterDetailsEvent extends Equatable {
  const SalesRegisterDetailsEvent();

  @override
  List<Object?> get props => [];
}

class FetchSalesRegisterDetails extends SalesRegisterDetailsEvent {
  final String startDate;
  final String endDate;

  const FetchSalesRegisterDetails({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}
