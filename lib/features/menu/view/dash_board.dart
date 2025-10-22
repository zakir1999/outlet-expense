import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outlet_expense/core/api/api_client.dart';
import 'package:outlet_expense/features/dashboard/chart/bloc/chart_bloc.dart';
import 'package:outlet_expense/features/dashboard/chart/view/chart_view.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: BlocProvider(
        create: (context) => ChartBloc(apiClient: ApiClient()),
        child: const ChartView(),
      ),
    );
  }
}

