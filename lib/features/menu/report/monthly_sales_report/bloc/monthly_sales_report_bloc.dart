import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/api/api_client.dart';
import '../repository/monthly_sales_repository.dart';
import 'monthly_sales_report_event.dart';
import 'monthly_sales_report_state.dart';


class MonthlySaleReportBloc extends Bloc<MonthlySalesReportEvent, MonthlySalesReportState> {
  final MonthlySalesRepository repository;

  MonthlySaleReportBloc({required GlobalKey<NavigatorState> navigatorKey})
      : repository = MonthlySalesRepository(
    apiClient: ApiClient(navigatorKey: navigatorKey),
  ),
        super(MonthlySaleInitial()) {
    on<FetchMonthlySaleEvent>(_onFetchMonthlySaleReport);
  }

  Future<void> _onFetchMonthlySaleReport(
      FetchMonthlySaleEvent event, Emitter<MonthlySalesReportState> emit) async {
    emit(MonthlySaleLoading());
    try {
      final reportResponse = await repository.fetchMonthlySaleResponse(
        startDate: event.startDate,
        endDate: event.endDate,
        filter: event.filter,
        brandId: event.brandId,
      );
      emit(MonthlySaleLoaded(reportResponse));
    } catch (e) {
      emit(MonthlySaleError(e.toString()));
    }
  }
}
