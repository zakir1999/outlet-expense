class ChartData {
  final List<String> labels;
  final List<num> values;
  final num sales;
  final num expenses;
  final num orders;
  final num customers;
  final num balance;
  final String customerPercentage;
  final num income;
  final num purchase;

  ChartData({
    required this.labels,
    required this.values,
    required this.sales,
    required this.expenses,
    required this.orders,
    required this.customers,
    required this.balance,
    required this.customerPercentage,
    required this.income,
    required this.purchase,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    final chartList = json['revenue_chart'] ?? [];
    return ChartData(
      labels: List<String>.from(chartList.map((e) => e['name'] as String)),
      values: List<num>.from(chartList.map((e) => e['amount'] as num)),
      sales: json['sales'] ?? 0,
      expenses: json['expense'] ?? 0,
      orders: json['order'] ?? 0,
      customers: json['new_customer'] ?? 0,
      balance: json['balance'] ?? 0,
      customerPercentage: json['customer_percentage']?.toString() ?? '0%',
      income: json['income'] ?? 0,
      purchase: json['purchase'] ?? 0,
    );
  }
}
