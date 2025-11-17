import 'package:flutter/material.dart';

class ReportItem {
  final String title;
  final Color color;
  final IconData icon;

  const ReportItem({
    required this.title,
    required this.color,
    required this.icon,
  });
}

const List<ReportItem> reportItems = [
  ReportItem(
    title: 'Category Sale Report',
    icon: Icons.bar_chart,
    color: Color(0xFF3B82F6),
  ),
  ReportItem(
    title: 'IMEI/Serial Report',
    icon: Icons.qr_code,
    color: Color(0xFF2563EB),
  ),
  ReportItem(
    title: 'Sales Register Report',
    icon: Icons.receipt_long,
    color: Color(0xFF0284C7),
  ),
  ReportItem(
    title: 'Purchase Register Details Report',
    icon: Icons.receipt_long,
    color: Color(0xFF10B981),
  ),
  ReportItem(
    title: 'Product Stock Report',
    icon: Icons.inventory,
    color: Color(0xFF059669),
  ),
  ReportItem(
    title: 'Expense Type Wise Report',
    icon: Icons.money_off,
    color: Color(0xFF1E40AF),
  ),
  ReportItem(
    title: 'Employee Wise Sales Report',
    icon: Icons.people_alt,
    color: Color(0xFF14B8A6),
  ),
  ReportItem(
    title: 'Cash Book Details History',
    icon: Icons.book,
    color: Color(0xFFF59E0B),
  ),
  ReportItem(
    title: 'Monthly Sales Day Count Report',
    icon: Icons.calendar_month,
    color: Color(0xFFF97316),
  ),
  ReportItem(
    title: 'Monthly Purchase Day Count Report',
    icon: Icons.shopping_cart,
    color: Color(0xFFEA580C),
  ),
  ReportItem(
    title: 'Purchase Summary Report',
    icon: Icons.summarize,
    color: Color(0xFF64748B),
  ),
  ReportItem(
    title: 'Profit and Loss Account Report',
    icon: Icons.trending_up,
    color: Color(0xFF8B5CF6),
  ),
  ReportItem(
    title: 'Customer Summary Report',
    icon: Icons.person,
    color: Color(0xFF16A34A),
  ),
  ReportItem(
    title: 'Due Report History',
    icon: Icons.history,
    color: Color(0xFF6B7280),
  ),
];
