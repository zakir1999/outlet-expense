import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/report_bloc.dart';
import '../bloc/report_event.dart';
import '../bloc/report_state.dart';
import '../widgets/report_card.dart';

class _ReportItem {
  final String title;
  final Color color;
  final IconData icon;


  const _ReportItem({required this.title, required this.color,required this.icon});
}

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  final List<_ReportItem> _items = const [
    _ReportItem(
      title: 'Category Sale Report',
      icon: Icons.bar_chart,
      color: Color(0xFF3B82F6), // Soft primary blue
    ),
    _ReportItem(
      title: 'IMEI/Serial Report',
      icon: Icons.qr_code,
      color: Color(0xFF2563EB), // Medium royal blue
    ),
    _ReportItem(
      title: 'Sales Register Report',
      icon: Icons.receipt_long,
      color: Color(0xFF0284C7), // Modern light blue
    ),
    _ReportItem(
      title: 'Purchase Register Details Report',
      icon: Icons.receipt_long,
      color: Color(0xFF10B981), // Fresh emerald green
    ),
    _ReportItem(
      title: 'Product Stock Report',
      icon: Icons.inventory,
      color: Color(0xFF059669), // Professional green
    ),
    _ReportItem(
      title: 'Expense Type Wise Report',
      icon: Icons.money_off,
      color: Color(0xFF1E40AF), // Deep navy blue – finance vibe
    ),
    _ReportItem(
      title: 'Employee Wise Sales Report',
      icon: Icons.people_alt,
      color: Color(0xFF14B8A6), // Aqua teal – people/HR feel
    ),
    _ReportItem(
      title: 'Cash Book Details History',
      icon: Icons.book,
      color: Color(0xFFF59E0B), // Subtle amber – accounting tone
    ),
    _ReportItem(
      title: 'Monthly Sales Day Count Report',
      icon: Icons.calendar_month,
      color: Color(0xFFF97316), // Orange accent – event/schedule feel
    ),
    _ReportItem(
      title: 'Monthly Purchase Day Count Report',
      icon: Icons.shopping_cart,
      color: Color(0xFFEA580C), // Deep orange – purchase tone
    ),
    _ReportItem(
      title: 'Purchase Summary Report',
      icon: Icons.summarize,
      color: Color(0xFF64748B), // Slate gray – neutral summary tone
    ),
    _ReportItem(
      title: 'Profit and Loss Account Report',
      icon: Icons.trending_up,
      color: Color(0xFF8B5CF6), // Soft purple – analytical tone
    ),
    _ReportItem(
      title: 'Customer Summary Report',
      icon: Icons.person,
      color: Color(0xFF16A34A), // Fresh green – customer trust tone
    ),
    _ReportItem(
      title: 'Due Report History',
      icon: Icons.history,
      color: Color(0xFF6B7280), // Neutral gray – subdued tone
    ),
  ];



  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return BlocProvider(
      create: (context) => ReportBloc(),
      child: BlocListener<ReportBloc, ReportState>(
        listener: (context, state) {
          if (state is ReportNavigationRequested) {
            context.push(state.routeName);
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.6,
            shadowColor: Colors.black.withOpacity(0.05),
            centerTitle: true,
            title: Text(
              'Report List',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: GridView.builder(
              itemCount: _items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14.w,
                mainAxisSpacing: 18.h,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final item = _items[index];
                final isEvenIndex = index % 2 == 0;

                return ReportCard(
                  title: item.title,
                  icon: item.icon,
                  color: item.color,
                  onTap: () {
                    context.read<ReportBloc>().add(ReportCardTapped(title: item.title));
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
