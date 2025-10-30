import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResponsiveCell extends StatelessWidget {
  final String text;
  final bool bold;
  final TextAlign align;

  const ResponsiveCell({
    Key? key,
    required this.text,
    this.bold = false,
    this.align = TextAlign.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive font size
    double fontSize;
    if (screenWidth < 360) {
      fontSize = 11.sp;
    } else if (screenWidth < 600) {
      fontSize = 13.sp;
    } else {
      fontSize = 15.sp; // tablet
    }

    // Responsive padding
    double horizontalPadding = screenWidth < 360 ? 4.w : 6.w;
    double verticalPadding = screenWidth < 360 ? 4.h : 6.h;

    // Uniform row height
    double rowHeight;
    if (screenWidth < 360) {
      rowHeight = 40.h;
    } else if (screenWidth < 600) {
      rowHeight = 45.h;
    } else {
      rowHeight = 50.h;
    }

    // Responsive width
    double cellWidth;
    if (screenWidth < 360) {
      cellWidth = 60.w;
    } else if (screenWidth < 600) {
      cellWidth = 80.w;
    } else {
      cellWidth = 100.w;
    }

    return Container(
      constraints: BoxConstraints(
        minHeight: rowHeight,
        minWidth: cellWidth,
        maxWidth: cellWidth * 1.5,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black38, width: 0.5),
        ),
      ),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
          fontSize: fontSize,
        ),
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        maxLines: 1,
      ),
    );
  }
}
