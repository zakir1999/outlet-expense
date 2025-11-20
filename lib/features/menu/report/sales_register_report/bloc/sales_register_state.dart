import 'package:equatable/equatable.dart';
import '../model/sales_register_details_model.dart';

abstract class SalesRegisterState extends Equatable {
  const SalesRegisterState();

  @override
  List<Object?> get props => [];
}

class SalesRegisterInitial extends SalesRegisterState {}

class SalesRegisterLoading extends SalesRegisterState {}

class SalesRegisterLoaded extends SalesRegisterState {
  final SalesRegisterModel response;

  const SalesRegisterLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class SalesRegisterError extends SalesRegisterState {
  final String message;

  const SalesRegisterError(this.message);

  @override
  List<Object?> get props => [message];
}
