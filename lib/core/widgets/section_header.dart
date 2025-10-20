import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const SectionHeader({super.key, required this.title, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: onViewAll,
          child: Text(
            "View All",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.blueAccent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
