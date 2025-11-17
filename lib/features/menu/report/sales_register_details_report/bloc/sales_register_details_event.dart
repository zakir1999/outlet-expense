
import 'package:equatable/equatable.dart';
import '../model/sales_register_details_model.dart';

abstract class SalesRegisterDetailsState extends Equatable {
  const SalesRegisterDetailsState();

  @override
  List<Object?> get props => [];
}

class SalesRegisterDetailsInitial extends SalesRegisterDetailsState {}

class SalesRegisterDetailsLoading extends SalesRegisterDetailsState {}

class SalesRegisterDetailsLoaded extends SalesRegisterDetailsState {
  final SalesRegisterResponse response;

  const SalesRegisterDetailsLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class SalesRegisterDetailsError extends SalesRegisterDetailsState {
  final String message;

  const SalesRegisterDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}