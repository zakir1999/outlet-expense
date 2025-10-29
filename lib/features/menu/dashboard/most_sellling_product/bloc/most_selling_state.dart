import '../model/most_selling_model.dart';

abstract class MostSellingState {}

class MostSellingInitial extends MostSellingState {}

class MostSellingLoading extends MostSellingState {}

class MostSellingLoaded extends MostSellingState {
  final List<MostSellingProduct> allProducts;
  final List<MostSellingProduct> filteredProducts;

  MostSellingLoaded(this.allProducts, this.filteredProducts);
}

class MostSellingError extends MostSellingState {
  final String message;
  MostSellingError(this.message);
}
