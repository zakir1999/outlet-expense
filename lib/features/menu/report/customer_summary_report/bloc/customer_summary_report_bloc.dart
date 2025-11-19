// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../model/customer_summary_report_model.dart';
// import '../repository/customer_summary_report_repository.dart';
// import 'customer_summary_report_event.dart';
// import 'customer_summary_report_state.dart';
// class CustomerSummaryReportBloc
//     extends Bloc<CustomerSummaryReportEvent, CustomerSummaryReportState> {
//   final CustomerSummaryReportRepository repository;
//
//   CustomerSummaryReportBloc({required this.repository})
//       : super(CustomerSummaryInitial()) {
//     on<FetchCustomerOptions>(_onFetchCustomerOptions);
//     on<UpdateCustomerName>(_onUpdateCustomerName);
//     on<CustomerWiseUpdateDates>(_onUpdateDates);
//     on<FetchCustomerSummaryReportEvent>(_onFetchCustomerSummaryReport);
//   }
//
//   /// Fetch customer dropdown options
//   Future<void> _onFetchCustomerOptions(
//       FetchCustomerOptions event, Emitter<CustomerSummaryReportState> emit) async {
//     emit(CustomerSummaryLoading());
//     try {
//       final customers = await repository.fetchCustomer();
//       emit(CustomerSummaryLoaded(
//         data: [],
//         customerOptions: customers,
//         customerName: null,
//         startDate: null,
//         id:null,
//         endDate: null,
//         grandTotal: 0,
//         customerPage: 1,
//         hasMoreCustomer: customers.isNotEmpty,
//         loadingCustomer: false,
//       ));
//     } catch (e) {
//       emit(CustomerSummaryError(e.toString()));
//     }
//   }
//
//   /// Update selected customer
//   void _onUpdateCustomerName(
//       UpdateCustomerName event, Emitter<CustomerSummaryReportState> emit) {
//     if (state is CustomerSummaryLoaded) {
//       final s = state as CustomerSummaryLoaded;
//       emit(s.copyWith(customerName: event.customerName??s.customerName,id:event.id??s.id));
//     }
//   }
//
//   /// Update report start and end dates
//   void _onUpdateDates(
//       CustomerWiseUpdateDates event, Emitter<CustomerSummaryReportState> emit) {
//     if (state is CustomerSummaryLoaded) {
//       final s = state as CustomerSummaryLoaded;
//       emit(s.copyWith(startDate: event.startDate, endDate: event.endDate));
//     }
//   }
//
//     Future<void> _onFetchCustomerSummaryReport(
//         FetchCustomerSummaryReportEvent event,
//         Emitter<CustomerSummaryReportState> emit,
//         ) async {
//       if (state is! CustomerSummaryLoaded) return;
//       final s = state as CustomerSummaryLoaded;
//
//       emit(CustomerSummaryLoading());
//       try {
//         final res = await repository.fetchCustomerSummaryReport(
//           id: event.id.toString(),
//           startDate: event.startDate,
//           endDate: event.endDate,
//         );
//         DateTime? start = DateTime.parse(event.startDate);
//         DateTime? end = DateTime.parse(event.endDate);
//
//
//         emit(s.copyWith(
//           data: res.data,
//           grandTotal: res.grandTotal,
//           startDate:start,
//           endDate:end,
//           id: event.id,
//           customerName: s.customerOptions.firstWhere(
//                 (e) => e.id == event.id,
//             orElse: () => CustomerItem(id: event.id, name: s.customerName ?? ''),
//           ).name,
//         ));
//       } catch (e) {
//         emit(CustomerSummaryError(e.toString()));
//       }
//     }
//
//
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/customer_summary_report_model.dart';
import '../repository/customer_summary_report_repository.dart';
import 'customer_summary_report_event.dart';
import 'customer_summary_report_state.dart';

class CustomerSummaryReportBloc
    extends Bloc<CustomerSummaryReportEvent, CustomerSummaryReportState> {
  final CustomerSummaryReportRepository repository;

  CustomerSummaryReportBloc({required this.repository})
      : super(CustomerSummaryInitial()) {
    on<FetchCustomerOptions>(_onFetchCustomerOptions);
    on<UpdateCustomerName>(_onUpdateCustomerName);
    on<CustomerWiseUpdateDates>(_onUpdateDates);
    on<FetchCustomerSummaryReportEvent>(_onFetchCustomerSummaryReport);
  }

  /// Fetch customer dropdown options
  Future<void> _onFetchCustomerOptions(
      FetchCustomerOptions event, Emitter<CustomerSummaryReportState> emit) async {
    emit(CustomerSummaryLoading());
    try {
      final customers = await repository.fetchCustomer();
      emit(CustomerSummaryLoaded(
        data: const [],
        customerOptions: customers,
        customerName: null,
        startDate: null,
        id: null,
        endDate: null,
        grandTotal: 0,
        customerPage: 1,
        hasMoreCustomer: customers.isNotEmpty,
        loadingCustomer: false,
      ));
    } catch (e) {
      emit(CustomerSummaryError(e.toString()));
    }
  }

  /// Update selected customer
  void _onUpdateCustomerName(
      UpdateCustomerName event, Emitter<CustomerSummaryReportState> emit) {
    if (state is CustomerSummaryLoaded) {
      final s = state as CustomerSummaryLoaded;
      emit(
        s.copyWith(
          customerName: event.customerName ?? s.customerName,
          id: event.id ?? s.id,
        ),
      );
    }
  }

  /// Update start & end dates
  void _onUpdateDates(
      CustomerWiseUpdateDates event, Emitter<CustomerSummaryReportState> emit) {
    if (state is CustomerSummaryLoaded) {
      final s = state as CustomerSummaryLoaded;
      emit(
        s.copyWith(
          startDate: event.startDate,
          endDate: event.endDate,
        ),
      );
    }
  }

  /// Fetch report data
  Future<void> _onFetchCustomerSummaryReport(
      FetchCustomerSummaryReportEvent event,
      Emitter<CustomerSummaryReportState> emit) async {
    if (state is! CustomerSummaryLoaded) return;
    final s = state as CustomerSummaryLoaded;

    emit(CustomerSummaryLoading());

    try {
      final res = await repository.fetchCustomerSummaryReport(
        id: event.id.toString(),
        startDate: event.startDate,
        endDate: event.endDate,
      );

      // Parse dates safely
      final start = event.startDate != null ? DateTime.tryParse(event.startDate!) : null;
      final end = event.endDate != null ? DateTime.tryParse(event.endDate!) : null;

      emit(
        s.copyWith(
          data: res.data.invoiceList, // updated according to model
          grandTotal: res.grandNetTotal, // updated according to model
          startDate: start,
          endDate: end,
          id: event.id,
          customerName: s.customerOptions.firstWhere(
                (e) => e.id == event.id,
            orElse: () => CustomerItem(id: event.id, name: s.customerName ?? ''),
          ).name,
        ),
      );
    } catch (e) {
      emit(CustomerSummaryError(e.toString()));
    }
  }
}
