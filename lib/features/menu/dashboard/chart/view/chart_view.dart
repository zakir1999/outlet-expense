import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:outlet_expense/features/menu/dashboard/chart/bloc/chart_bloc.dart';
import 'package:outlet_expense/features/menu/dashboard/chart/widgets/chart_widget.dart';
import 'package:outlet_expense/features/menu/dashboard/chart/widgets/interval_buttons.dart';
import 'package:outlet_expense/features/menu/dashboard/chart/widgets/summary_card.dart';
import '../widgets/info_label.dart';

import '../widgets/recent_oder.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.04;
    final verticalPadding = screenWidth * 0.03;
    final horizontalMargin = screenWidth * 0.02;

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5A7BFF), Color(0xFF8BBEFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: IntervalButtons(),
              ),

              BlocBuilder<ChartBloc, ChartState>(
                builder: (context, state) {
                  if (state is ChartLoading) {
                    return SizedBox(
                      height: screenHeight * 0.30,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  } else if (state is ChartLoaded) {
                    return Column(
                      children: [
                        // Chart
                        SizedBox(
                          height: screenHeight * 0.30,
                          width: double.infinity,
                          child: ChartWidget(data: {
                            'labels': state.chartData.labels,
                            'values': state.chartData.values,
                          },),
                        ),


                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                              top: 15, left: 2, right: 0, bottom: 10),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF9F9FF),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),

                            ),
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [



                              SizedBox(
                                height: screenHeight * 0.16,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  children: [
                                Container(
                                margin: EdgeInsets.only(bottom: 10.0, top: 5.0),
                                    child:
                                    SummaryCard(
                                      color: Colors.purple,
                                      title: "Total Sales",
                                      value: "${state.chartData.sales}৳",
                                      icon: Icons.pie_chart,
                                    ),
                                ),

                                Container(
                                  margin: EdgeInsets.only(bottom: 10.0, top: 5.0),
                                  child:
                                  SummaryCard(
                                      color: Colors.orange,
                                      title: "Total Expense",
                                      value: "${state.chartData.expenses}৳",
                                      icon: Icons.shopping_cart,
                                    ),
                                ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10.0, top: 5.0), // Margin only on left and top
                                      child:
                                    SummaryCard(
                                      color: Colors.teal,
                                      title: "Orders",
                                      value: "${state.chartData.orders}",
                                      icon: Icons.timer,
                                    ),
                                    ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10.0, top: 5.0),
                            child:
                                    SummaryCard(
                                      color: Colors.green,
                                      title: "Customers",
                                      value: "${state.chartData.customers}",
                                      icon: Icons.person,
                                      customerPercentage:
                                      "${state.chartData.customerPercentage}",
                                    ),
                          ),
                                  ],
                                ),
                              ),


                              const SizedBox(height: 20),

                              // Total Balance Card
                              Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                                  margin: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 8.0),

                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Total Balance",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "${state.chartData.balance} ৳",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          InfoLabel(
                                            label: "Spent",
                                            value: "${state.chartData.income}৳",
                                            color: Colors.red,
                                          ),
                                          InfoLabel(
                                            label: "Income",
                                            value: "${state.chartData.expenses}৳",
                                            color: Colors.green,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              RecentOrderOneValue(
                                orderValue: 'Recent Orders',
                                onPressed: () {
                                  context.push('/recent-orders');
                                },
                              ),
                              RecentOrderOneValue(
                                orderValue: 'Most Selling Products',
                                onPressed: () {
                                  context.push('/most-selling');
                                },
                              ),
                              RecentOrderOneValue(
                                orderValue: 'Recent Purchase',
                                onPressed: () {
                                  context.push('/purchase-invoice');
                                },
                              ),

                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (state is ChartError) {
                    return SizedBox(
                      height: screenHeight * 0.30,
                      child: Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: screenHeight * 0.30,
                      child: const Center(
                        child: Text(
                          'No data available',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
