import 'package:equatable/equatable.dart';
import '../model/production_stock_model.dart';

abstract class ProductionStockState extends Equatable {
  const ProductionStockState();

  @override
  List<Object?> get props => [];
}

class ProductionStockInitial extends ProductionStockState {}

class ProductionStockLoading extends ProductionStockState {}

class ProductionStockLoaded extends ProductionStockState {
  final ProductionStockResponse response;

  const ProductionStockLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class ProductionStockError extends ProductionStockState {
  final String message;

  const ProductionStockError(this.message);

  @override
  List<Object?> get props => [message];
}
