import 'package:flutter/material.dart';

class InvoiceCard extends StatelessWidget {
  final String id;
  final String customerName;
  final String createdAt;
  final double amount;

  const InvoiceCard({
    Key? key,
    required this.id,
    required this.customerName,
    required this.createdAt,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: isLargeScreen
          ? _buildHorizontalLayout(context)
          : _buildVerticalLayout(context),
    );
  }

  /// Layout for small devices (mobile)
  Widget _buildVerticalLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoRow(Icons.receipt_long, 'Invoice ID', id),
        const SizedBox(height: 8),
        _infoRow(Icons.person, 'Customer', customerName),
        const SizedBox(height: 8),
        _infoRow(Icons.calendar_today, 'Date', createdAt),
        const SizedBox(height: 8),
        _infoRow(Icons.attach_money, 'Amount', '৳ ${amount.toStringAsFixed(2)}',
            isHighlight: true),
      ],
    );
  }

  /// Layout for tablet/web
  Widget _buildHorizontalLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _infoRow(Icons.receipt_long, 'Invoice', id)),
        Expanded(child: _infoRow(Icons.person, 'Customer', customerName)),
        Expanded(child: _infoRow(Icons.calendar_today, 'Date', createdAt)),
        Expanded(
          child: _infoRow(
            Icons.attach_money,
            'Amount',
            '৳ ${amount.toStringAsFixed(2)}',
            isHighlight: true,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value,
      {bool isHighlight = false}) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.shade600, height: 1.3)),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
                  color: isHighlight ? Colors.green.shade700 : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
