import 'package:flutter/material.dart';

class RecentOrderOneValue extends StatelessWidget {
  final String orderValue;
  final VoidCallback onPressed;

  const RecentOrderOneValue({
    super.key,
    required this.orderValue,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final horizontalPadding = screenWidth * 0.04;
    final verticalPadding = screenWidth * 0.03;
    final horizontalMargin = screenWidth * 0.02;
    final buttonSize = screenWidth * 0.095;
    final iconSize = screenWidth * 0.055;
    final valueFontSize = screenWidth * 0.04;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              orderValue,
              style: TextStyle(
                fontSize: valueFontSize,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
          Container(
            width: buttonSize,
            height: buttonSize,
            decoration: const BoxDecoration(
              color: Color(0xFF06B6D4),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: iconSize,
              icon: const Icon(Icons.chevron_right, color: Colors.white),
              onPressed: onPressed,

            ),
          ),
        ],
      ),
    );
  }
}
