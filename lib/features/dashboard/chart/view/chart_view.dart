import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:outlet_expense/features/dashboard/chart/bloc/chart_bloc.dart';
import 'package:outlet_expense/features/dashboard/chart/widgets/chart_widget.dart';
import 'package:outlet_expense/features/dashboard/chart/widgets/interval_buttons.dart';
import 'package:outlet_expense/features/dashboard/chart/widgets/summary_card.dart';
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
              // Interval Buttons
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: IntervalButtons(),
              ),

              // Chart Section
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
                          child: ChartWidget(data: state.data),
                        ),

                        // Bottom White Area
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                              top: 20, left: 16, right: 16, bottom: 20),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF9F9FF),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(28),
                              topRight: Radius.circular(28),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Horizontal summary cards
                              SizedBox(
                                height: screenHeight * 0.16,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    SummaryCard(
                                      color: Colors.purple,
                                      title: "Total Sales",
                                      value: "${state.sales}৳",
                                      icon: Icons.pie_chart,
                                    ),
                                    SummaryCard(
                                      color: Colors.orange,
                                      title: "Total Expense",
                                      value: "${state.expenses}৳",
                                      icon: Icons.shopping_cart,
                                    ),
                                    SummaryCard(
                                      color: Colors.teal,
                                      title: "Orders",
                                      value: "${state.orders}",
                                      icon: Icons.timer,
                                    ),
                                    SummaryCard(
                                      color: Colors.green,
                                      title: "Customers",
                                      value: "${state.customers}",
                                      icon: Icons.person,
                                      customer_percentage:
                                      "${state.customer_percentage}",
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Total Balance Card
                              Container(
                                width: screenWidth * 0.9,
                                padding: const EdgeInsets.all(16),
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
                                      "${state.balance} ৳",
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
                                          value: "${state.income}৳",
                                          color: Colors.red,
                                        ),
                                        InfoLabel(
                                          label: "Income",
                                          value: "${state.expenses}৳",
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              RecentOrderOneValue(
                                orderValue: 'Recent Orders',
                                onPressed: () {
                                  // Example navigation
                                  context.push('/recent-orders');
                                },
                              ),
                              RecentOrderOneValue(
                                orderValue: 'Most Selling Products',
                                onPressed: () {
                                  context.go('/most-selling');
                                },
                              ),
                              RecentOrderOneValue(
                                orderValue: 'Recent Purchase',
                                onPressed: () {
                                  context.go('/recent-purchase');
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
