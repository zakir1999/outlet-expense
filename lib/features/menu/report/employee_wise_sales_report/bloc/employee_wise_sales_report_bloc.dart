import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/employee_wise_sales_report_model.dart';
import '../repository/employee_wise_sales_report_repository.dart';
import 'employee_wise_sales_report_event.dart';
import 'employee_wise_sales_report_state.dart';
class EmployeeWiseSalesReportBloc
    extends Bloc<EmployeeWiseSalesReportEvent, EmployeeWiseSalesReportState> {
  final EmployeeWiseSalesReportRepository repository;

  EmployeeWiseSalesReportBloc({required this.repository})
      : super(EmployeeWiseSalesInitial()) {
    on<FetchEmployeeOptions>(_onFetchEmployeeOptions);
    on<UpdateEmployeeName>(_onUpdateEmployeeName);
    on<EmployeeWiseUpdateDates>(_onUpdateDates);
    on<FetchEmployeeWiseSalesReportEvent>(_onFetchEmployeeReport);
  }

  Future<void> _onFetchEmployeeOptions(
      FetchEmployeeOptions event, Emitter<EmployeeWiseSalesReportState> emit) async {
    emit(EmployeeWiseSalesLoading());
    try {
      final employees = await repository.fetchEmployee();
      emit(EmployeeWiseSalesLoaded(
        data: [],
        employeeOptions: employees,
        employeeName: null,
        startDate: null,
        id:null,
        endDate: null,
        grandTotal: 0,
        employeePage: 1,
        hasMoreEmployee: employees.isNotEmpty,
        loadingEmployee: false,
      ));
    } catch (e) {
      emit(EmployeeWiseSalesError(e.toString()));
    }
  }

  /// Update selected employee
  void _onUpdateEmployeeName(
      UpdateEmployeeName event, Emitter<EmployeeWiseSalesReportState> emit) {
    if (state is EmployeeWiseSalesLoaded) {
      final s = state as EmployeeWiseSalesLoaded;
      emit(s.copyWith(employeeName: event.employeeName??s.employeeName,id:event.id??s.id));
    }
  }

  /// Update report start and end dates
  void _onUpdateDates(
      EmployeeWiseUpdateDates event, Emitter<EmployeeWiseSalesReportState> emit) {
    if (state is EmployeeWiseSalesLoaded) {
      final s = state as EmployeeWiseSalesLoaded;
      emit(s.copyWith(startDate: event.startDate, endDate: event.endDate));
    }
  }

    Future<void> _onFetchEmployeeReport(
        FetchEmployeeWiseSalesReportEvent event,
        Emitter<EmployeeWiseSalesReportState> emit,
        ) async {
      if (state is! EmployeeWiseSalesLoaded) return;
      final s = state as EmployeeWiseSalesLoaded;

      emit(EmployeeWiseSalesLoading());
      try {
        final res = await repository.fetchEmployWiseSalesReport(
          id: event.id,
          startDate: event.startDate,
          endDate: event.endDate,
        );
        DateTime? start = DateTime.parse(event.startDate);
        DateTime? end = DateTime.parse(event.endDate);


        emit(s.copyWith(
          data: res.data,
          grandTotal: res.grandTotal,
          startDate:start,
          endDate:end,
          id: event.id,
          employeeName: s.employeeOptions.firstWhere(
                (e) => e.id == event.id,
            orElse: () => EmployeeItem(id: event.id, name: s.employeeName ?? ''),
          ).name,
        ));
      } catch (e) {
        emit(EmployeeWiseSalesError(e.toString()));
      }
    }


}
