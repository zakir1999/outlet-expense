import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/employee_wise_sales_report_model.dart';
import 'employee_wise_sales_report_event.dart';
import 'employee_wise_sales_report_state.dart';

import '../repository/employee_wise_sales_report_repository.dart';
class EmployeeWiseSalesReportBloc extends Bloc<EmployeeWiseSalesReportEvent, EmployeeWiseSalesReportState> {
  final EmployeeWiseSalesReportRepository repository;

  EmployeeWiseSalesReportBloc({required this.repository}) : super(EmployeeWiseSalesInitial()) {
    on<FetchEmployeeWiseSalesReportEvent>(_onFetchEmployeeWiseSalesReport);
  }

  Future<void> _onFetchEmployeeWiseSalesReport(
      FetchEmployeeWiseSalesReportEvent event,
      Emitter<EmployeeWiseSalesReportState> emit,
      ) async {
    emit(const EmployeeWiseSalesLoading());
    try {
      final res = await repository.fetchEmployWiseSalesReport(
        startDate: event.startDate,
        endDate: event.endDate,
        id: event.id,
      );


      emit(EmployeeWiseSalesLoaded(
        data: res.data,
        grandTotal: res.grandTotal,
      ));
    } catch (e) {
      emit(EmployeeWiseSalesError(e.toString()));
    }
  }

}
