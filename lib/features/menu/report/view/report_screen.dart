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
    _ReportItem(title: 'Category Sale Report', icon: Icons.bar_chart, color: Color(0xFF00897B)),
    _ReportItem(title: 'IMEI/Serial Report', icon: Icons.qr_code, color: Color(0xFF3949AB)),
    _ReportItem(title: 'Sales Register Details Report', icon: Icons.receipt_long, color: Color(0xFF1976D2)),
    _ReportItem(title: 'Product Stock Report', icon: Icons.inventory, color: Color(0xFF388E3C)),
    _ReportItem(title: 'Expense Type Wise Report', icon: Icons.money_off, color: Color(0xFF1E3A8A)),
    _ReportItem(title: 'Employee Wise Sales Report', icon: Icons.people_alt, color: Color(0xFF26A69A)),
    _ReportItem(title: 'Cash Book Details History', icon: Icons.book, color: Color(0xFF9E9D24)),
    _ReportItem(title: 'Monthly Sales Day Counting Report', icon: Icons.calendar_month, color: Color(0xFFFFB300)),
    _ReportItem(title: 'Monthly Purchase Day Counting Report', icon: Icons.shopping_cart, color: Color(0xFFF4511E)),
    _ReportItem(title: 'Purchase Summary Report', icon: Icons.summarize, color: Color(0xFF546E7A)),
    _ReportItem(title: 'Profit and Loss Account Report', icon: Icons.trending_up, color: Color(0xFF8E24AA)),
    _ReportItem(title: 'Customer Summary Report', icon: Icons.person, color: Color(0xFF2E7D32)),
    _ReportItem(title: 'Due Report History', icon: Icons.history, color: Color(0xFF6D4C41)),
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
