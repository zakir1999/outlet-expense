class Invoice {
  final String id;
  final String customerName;
  final double amount;
  final String type;
  final String createdAt;

  Invoice({
    required this.id,
    required this.customerName,
    required this.amount,
    required this.type,
    required this.createdAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['invoice_id']?.toString() ?? 'Unknown',
      customerName: json['customer_name']?.toString() ?? 'Unknown',
      amount: double.tryParse(json['paid_amount']?.toString() ?? '0') ?? 0,
      type: json['type']?.toString() ??
          (json['is_purchase'] == true ? 'Pur' : 'Inv'),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}
