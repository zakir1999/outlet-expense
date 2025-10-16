import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outlet_expense/features/dashboard/chart/bloc/chart_bloc.dart';
import 'package:outlet_expense/features/dashboard/chart/widgets/chart_widget.dart';
import 'package:outlet_expense/features/dashboard/chart/widgets/interval_buttons.dart';

class ChartView extends StatefulWidget {
  const ChartView({super.key});

  @override
  State<ChartView> createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  @override
  void initState() {
    super.initState();
    context.read<ChartBloc>().add(const FetchChartData('daily'));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          const IntervalButtons(),
          BlocBuilder<ChartBloc, ChartState>(
            builder: (context, state) {
              if (state is ChartLoading) {
                return const Expanded(
                    child: Center(child: CircularProgressIndicator()));
              } else if (state is ChartLoaded) {
                return SizedBox(
                  height: screenHeight * 0.50, // Fixed height
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Chart width depends on label count
                        SizedBox(
                          width: state.data['labels'].length * 60.0,
                          child: ChartWidget(data: state.data),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is ChartError) {
                return Expanded(child: Center(child: Text(state.message)));
              } else {
                return const Expanded(child: Center(child: Text('No data')));
              }
            },
          ),
        ],
      ),
    );
  }
}
