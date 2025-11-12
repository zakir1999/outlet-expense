// lib/features/reports/sales_register/bloc/sales_register_details_state.dart
import 'package:equatable/equatable.dart';
import '../model/sales_register_details_model.dart';

abstract class SalesRegisterDetailsState extends Equatable {
  const SalesRegisterDetailsState();

  @override
  List<Object?> get props => [];
}

class SalesRegisterInitial extends SalesRegisterDetailsState {}

class SalesRegisterLoading extends SalesRegisterDetailsState {}

class SalesRegisterLoaded extends SalesRegisterDetailsState {
  final SalesRegisterDetailsModel response;

  const SalesRegisterLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class SalesRegisterError extends SalesRegisterDetailsState {
  final String message;

  const SalesRegisterError(this.message);

  @override
  List<Object?> get props => [message];
}
