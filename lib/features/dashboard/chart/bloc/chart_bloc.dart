import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

part 'chart_event.dart';
part 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  ChartBloc() : super(ChartInitial()) {
    on<FetchChartData>(_onFetchChartData);
  }

  Future<void> _onFetchChartData(
      FetchChartData event,
      Emitter<ChartState> emit,
      ) async {
    emit(ChartLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(const ChartError('Not authenticated'));
        return;
      }

      final response = await http.get(
        Uri.parse(
          'https://www.outletexpense.xyz/api/web-dashboard?interval=${event.interval}',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final dashboardData = jsonResponse['data'];
        final chartList = dashboardData['revenue_chart'] ?? [];
        final labels = chartList.map<String>((e) => e['name'] as String).toList();
        final values = chartList.map<num>((e) => e['amount'] as num).toList();
        final formattedData = {
          'labels': labels,
          'values': values,
        };

        emit(ChartLoaded(formattedData));
      } else {
        emit(ChartError('Failed to fetch data: ${response.body}'));
      }
    } catch (e) {
      emit(ChartError('Failed to fetch data: $e'));
    }
  }

}
