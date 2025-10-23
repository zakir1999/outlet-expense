import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outlet_expense/core/api/api_client.dart';
import 'package:outlet_expense/features/dashboard/chart/bloc/chart_bloc.dart';
import 'package:outlet_expense/features/dashboard/chart/view/chart_view.dart';
import 'package:outlet_expense/features/dashboard/chart/repository/chart_repository.dart'; // <<< NEW IMPORT HERE

import '../../../main.dart'; // Assuming this provides the global navigatorKey

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Create the ApiClient first
    final apiClient = ApiClient(navigatorKey: navigatorKey); // <<< NEW CODE HERE

    // 2. Create the ChartRepository, passing the apiClient
    final chartRepository = ChartRepository(apiClient: apiClient); // <<< NEW CODE HERE

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: BlocProvider(
        // 3. Pass the REQUIRED chartRepository to the ChartBloc
        // This fixes both: the missing 'chartRepository' argument error,
        // and the undefined 'apiClient' parameter error.
        create: (context) => ChartBloc(chartRepository: chartRepository), // <<< CHANGED LINE
        child: const ChartView(),
      ),
    );
  }
}