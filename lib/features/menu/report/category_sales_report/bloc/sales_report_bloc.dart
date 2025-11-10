import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outlet_expense/features/menu/report/category_sales_report/bloc/sales_report_event.dart';
import 'package:outlet_expense/features/menu/report/category_sales_report/bloc/sales_report_state.dart';
import '../repository/sales_repository.dart';
import '../../../../../core/api/api_client.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository repository;

  ReportBloc({required GlobalKey<NavigatorState> navigatorKey})
      : repository = ReportRepository(
    apiClient: ApiClient(navigatorKey: navigatorKey),
  ),
        super(ReportInitial()) {
    on<FetchReportEvent>(_onFetchReport);
  }

  Future<void> _onFetchReport(
      FetchReportEvent event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      final reportResponse = await repository.fetchReportDataResponse(
        startDate: event.startDate,
        endDate: event.endDate,
        filter: event.filter,
        brandId: event.brandId,
      );
      emit(ReportLoaded(reportResponse));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }
}
