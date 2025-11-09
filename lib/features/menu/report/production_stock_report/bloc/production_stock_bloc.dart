import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'production_stock_event.dart';
part 'production_stock_state.dart';

class ProductionStockBloc extends Bloc<ProductionStockEvent, ProductionStockState> {
  ProductionStockBloc() : super(ProductionStockInitial()) {
    on<ProductionStockEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
