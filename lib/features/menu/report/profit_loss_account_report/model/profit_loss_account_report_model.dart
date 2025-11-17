
import 'package:equatable/equatable.dart';

class ProfitLossReport extends Equatable {
  final int grossProfit;
  final int netProfit;
  final Map<String, int> expenses;
  final int totalExpenses;

  const ProfitLossReport({
    required this.grossProfit,
    required this.netProfit,
    required this.expenses,
    required this.totalExpenses,
  });

  // Helper to safely parse numbers from various types (int, double, String).
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory ProfitLossReport.fromJson(Map<String, dynamic> json) {
    // Safely parse the expenses map
    final Map<String, int> expensesMap = {};
    if (json['expenses'] is Map) {
      (json['expenses'] as Map).forEach((key, value) {
        expensesMap[key.toString()] = _parseInt(value);
      });
    }

    return ProfitLossReport(
      grossProfit: _parseInt(json['gross_profit']),
      netProfit: _parseInt(json['net_profit']),
      expenses: expensesMap,
      totalExpenses: _parseInt(json['total_expenses']),
    );
  }

  @override
  List<Object?> get props => [grossProfit, netProfit, expenses, totalExpenses];
}