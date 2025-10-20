import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListItemTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? trailing;
  final VoidCallback? onTap;

  const ListItemTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        margin: EdgeInsets.only(bottom: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 14.sp, fontWeight: FontWeight.w600)),
              4.verticalSpace,
              Text(subtitle, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
            ]),
            if (trailing != null)
              Text(trailing!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
          ],
        ),
      ),
    );
  }
}
