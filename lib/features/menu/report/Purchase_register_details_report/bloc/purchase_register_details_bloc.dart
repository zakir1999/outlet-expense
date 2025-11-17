import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../core/api/api_client.dart';
import '../model/purchase_register_details_model.dart';
import '../repository/purchase_register_details_repository.dart';
import 'purchase_register_details_event.dart';
import 'purchase_register_details_state.dart';

class PurchaseRegisterDetailsBloc extends Bloc<PurchaseRegisterDetailsEvent, PurchaseRegisterDetailsState> {
  final GlobalKey<NavigatorState>? navigatorKey;
  final PurchaseRegisterDetailsRepository repository;

  PurchaseRegisterDetailsBloc({
    this.navigatorKey,
    PurchaseRegisterDetailsRepository? repository,
  })  : repository = repository ??
      PurchaseRegisterDetailsRepository(
        apiClient: ApiClient(navigatorKey: navigatorKey),
      ),
        super(PurchaseRegisterDetailsInitial()) {
    on<FetchPurchaseRegisterDetailsEvent>(_onFetchPurchaseDetails);
  }

  Future<void> _onFetchPurchaseDetails(
      FetchPurchaseRegisterDetailsEvent event,
      Emitter<PurchaseRegisterDetailsState> emit) async {
    emit(PurchaseRegisterDetailsLoading());

    try {
      // fetch API
      final PurchaseRegisterResponse res = await repository.fetchPurchaseRegisterDetails(
        startDate: event.startDate,
        endDate: event.endDate,
      );

      // emit loaded state with the response
      emit(PurchaseRegisterDetailsLoaded(response: res));
    } catch (e) {
      emit(PurchaseRegisterDetailsError(e.toString()));
    }
  }
}
