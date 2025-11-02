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
  const _ReportItem({required this.title, required this.color});
}


class ReportScreen extends StatelessWidget {

  final List<_ReportItem> _items = const [
    _ReportItem(title: 'Category Sale Report', color: Color(0xFF165F68)),
    _ReportItem(title: 'Transaction History', color: Color(0xFF30386D)),
    _ReportItem(title: 'Product Sale Report', color: Color(0xFF5F5EC8)),
    _ReportItem(title: 'Product Stock Report', color: Color(0xFF166155)),
    _ReportItem(title: 'Balance History', color: Color(0xFF1D2981)),
    _ReportItem(title: 'Category Stock Report', color: Color(0xFF19A886)),
    _ReportItem(title: 'Accounting History Report', color: Color(0xFF708320)),
  ];

  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    // 1. Provide the ReportBloc instance to the widget tree.
    return BlocProvider(
      create: (context) => ReportBloc(),
      child: Builder(
        builder: (context) {
          // 2. Use BlocListener to handle side-effects (navigation).
          // It listens specifically for the ReportNavigationRequested state.
          return BlocListener<ReportBloc, ReportState>(
            listener: (context, state) {
              if (state is ReportNavigationRequested) {
                context.push('/sales-report');
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
                      color: item.color,
                      percentText: '↑ 0%',
                      isLeftCard: isEvenIndex,
                      // 3. Dispatch the Event on tap, notifying the BLoC.
                      onTap: () {
                        context
                            .read<ReportBloc>()
                            .add(ReportCardTapped(title: item.title));
                      },
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}