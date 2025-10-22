import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

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

  String _getTimeAgo(String date) {
    try {
      final parsed = DateTime.parse(date);
      return timeago.format(parsed);
    } catch (_) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeAgo = _getTimeAgo(createdAt);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 🔶 Left Icon (Orange Circle)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.orange.shade400, width: 1.2),
            ),
            child: Icon(
              Icons.attach_money,
              color: Colors.orange.shade600,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),

          // 🧾 Invoice Info (ID + Customer)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  id,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  customerName,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // 💰 Amount + Time Ago
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${amount.toStringAsFixed(1)}৳',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                timeAgo,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
