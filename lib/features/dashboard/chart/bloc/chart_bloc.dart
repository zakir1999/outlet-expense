import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/api_client.dart';

part 'chart_event.dart';
part 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final ApiClient apiClient;

  ChartBloc({required this.apiClient}) : super(ChartInitial()) {
    on<FetchChartData>(_onFetchChartData);
  }

  Future<void> _onFetchChartData(
      FetchChartData event,
      Emitter<ChartState> emit,
      ) async {
    emit(ChartLoading());
    try {
      final response = await apiClient.get('web-dashboard?interval=${event.interval}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final dashboardData = jsonResponse['data'];
        final chartList = dashboardData['revenue_chart'] ?? [];
        final labels =
        chartList.map<String>((e) => e['name'] as String).toList();
        final values =
        chartList.map<num>((e) => e['amount'] as num).toList();

        final formattedData = {
          'labels': labels,
          'values': values,
        };

        final sales = dashboardData['sales'] ?? 0;
        final expenses = dashboardData['expense'] ?? 0;
        final orders = dashboardData['order'] ?? 0;
        final customers = dashboardData['new_customer'] ?? 0;
        final balance = dashboardData['balance'] ?? 0;
        final customer_percentage = dashboardData['customer_percentage'].toString();
        final income = dashboardData['income'] ?? 0;
        final purchase = dashboardData['purchase'] ?? 0;
        emit(ChartLoaded(
          data: formattedData,
          sales: sales,
          expenses: expenses,
          orders: orders,
          customers: customers,
          balance:balance,
            customer_percentage:customer_percentage,
          income: income,
          purchase: purchase
        ));
      } else {
        emit(ChartError('Failed to fetch data: ${response.body}'));
      }
    } catch (e) {
      emit(ChartError('Failed to fetch data: $e'));
    }
  }
}
