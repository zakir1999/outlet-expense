import 'package:equatable/equatable.dart';
import '../model/purchase_register_details_model.dart';

abstract class PurchaseRegisterDetailsState extends Equatable {
  const PurchaseRegisterDetailsState();

  @override
  List<Object?> get props => [];
}

class PurchaseRegisterDetailsInitial extends PurchaseRegisterDetailsState {}

class PurchaseRegisterDetailsLoading extends PurchaseRegisterDetailsState {}

class PurchaseRegisterDetailsLoaded extends PurchaseRegisterDetailsState {
  final PurchaseRegisterResponse response;

  const PurchaseRegisterDetailsLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class PurchaseRegisterDetailsError extends PurchaseRegisterDetailsState {
  final String message;

  const PurchaseRegisterDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
