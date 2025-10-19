part of 'chart_bloc.dart';

abstract class ChartState extends Equatable {
  const ChartState();

  @override
  List<Object> get props => [];
}

// Initial state
class ChartInitial extends ChartState {}

// Loading state
class ChartLoading extends ChartState {}

// Loaded state with chart data and summary values
class ChartLoaded extends ChartState {
  final Map<String, dynamic> data;
  final num sales;
  final num expenses;
  final num orders;
  final num customers;
  final num balance;
  final String customer_percentage;
  final num income;
  final num purchase;


  const ChartLoaded({
    required this.data,
    this.income = 0,
    this.purchase = 0,
    required this.sales,
    required this.expenses,
    required this.orders,
    required this.customers,
    required this.balance,
    required this.customer_percentage,
  });

  @override
  List<Object> get props => [data, sales, expenses, orders, customers,balance,customer_percentage,income,purchase];
}

// Error state
class ChartError extends ChartState {
  final String message;

  const ChartError(this.message);

  @override
  List<Object> get props => [message];
}
