import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outlet_expense/core/api/api_client.dart';
import 'package:outlet_expense/features/menu/dashboard/chart/bloc/chart_bloc.dart';
import 'package:outlet_expense/features/menu/dashboard/chart/view/chart_view.dart';
import 'package:outlet_expense/features/menu/dashboard/chart/repository/chart_repository.dart';

import '../../../main.dart';
class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient(navigatorKey: navigatorKey);
    final chartRepository = ChartRepository(apiClient: apiClient);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: BlocProvider(
        create: (context) => ChartBloc(chartRepository: chartRepository),
        child: const ChartView(),
      ),
    );
  }
}