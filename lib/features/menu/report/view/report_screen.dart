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

  const _ReportItem({required this.title, required this.color, required this.icon});
}

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  final List<_ReportItem> _items = const [
    _ReportItem(
      title: 'Category Sale Report',
      icon: Icons.bar_chart,
      color: Color(0xFF3B82F6),
    ),
    _ReportItem(
      title: 'IMEI/Serial Report',
      icon: Icons.qr_code,
      color: Color(0xFF11AA9C),
    ),
    _ReportItem(
      title: 'Sales Register Report',
      icon: Icons.receipt_long,
      color: Color(0xFF0284C7),
    ),
    _ReportItem(
      title: 'Purchase Register Details Report',
      icon: Icons.receipt_long,
      color: Color(0xFF0216EF),
    ),
    _ReportItem(
      title: 'Sales Register Details Report',
      icon: Icons.receipt_long,
      color: Color(0xFFA6ED37),
    ),
    _ReportItem(
      title: 'Product Stock Report',
      icon: Icons.inventory,
      color: Colors.deepOrange,
    ),
    _ReportItem(
      title: 'Expense Type Wise Report',
      icon: Icons.money_off,
      color: Color(0xFF1E40AF),
    ),
    _ReportItem(
      title: 'Employee Wise Sales Report',
      icon: Icons.people_alt,
      color: Colors.deepPurpleAccent,
    ),
    _ReportItem(
      title: 'Cash Book Details History',
      icon: Icons.book,
      color: Color(0xFFF59E0B),
    ),
    _ReportItem(
      title: 'Monthly Sales Day Count Report',
      icon: Icons.calendar_month,
      color: Color(0xFFF97316),
    ),
    _ReportItem(
      title: 'Monthly Purchase Day Count Report',
      icon: Icons.shopping_cart,
      color: Colors.purple,
    ),
    _ReportItem(
      title: 'Purchase Summary Report',
      icon: Icons.summarize,
      color: Colors.pink,
    ),
    _ReportItem(
      title: 'Profit & Loss Account Report',
      icon: Icons.trending_up,
      color: Color(0xFF8B5CF6),
    ),
    _ReportItem(
      title: 'Customer Summary Report',
      icon: Icons.person,
      color: Color(0xFF16A34A),
    ),
    _ReportItem(
      title: 'Due Report History',
      icon: Icons.history,
      color: Color(0xFF6B7280),
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
            child:GridView.custom(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14.w,
                mainAxisSpacing: 18.h,
                childAspectRatio: 1.1,
              ),
              childrenDelegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final item = _items[index];

                  return ReportCard(
                    title: item.title,
                    icon: item.icon,
                    color: item.color,
                    onTap: () {
                      context
                          .read<ReportBloc>()
                          .add(ReportCardTapped(title: item.title));
                    },
                  );
                },
                childCount: _items.length,
              ),
            ),

          ),
        ),
      ),
    );
  }
}
