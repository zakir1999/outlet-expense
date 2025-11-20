import 'package:equatable/equatable.dart';
import '../model/category_sales_report_model.dart';

abstract class CategorySaleReportState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategorySaleInitial extends CategorySaleReportState {}

class CategorySaleLoading extends CategorySaleReportState {}

class CategorySaleLoaded extends CategorySaleReportState {
  final CategorySaleResponse reportResponse;

  CategorySaleLoaded(this.reportResponse);

  @override
  List<Object?> get props => [reportResponse];
}

class CategorySaleError extends CategorySaleReportState {
  final String message;

  CategorySaleError(this.message);

  @override
  List<Object?> get props => [message];
}
