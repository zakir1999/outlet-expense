import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ResponsiveShimmer extends StatelessWidget {
  final double? itemHeight;
  final double? itemMargin;
  final double? maxWidth; // optional, container width control
  const ResponsiveShimmer({
    super.key,
    this.itemHeight,
    this.itemMargin,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Mobile/Tablet অনুযায়ী default height & margin
    final height = itemHeight ?? (screenWidth < 600 ? 60.0 : 80.0);
    final margin = itemMargin ?? (screenWidth < 600 ? 8.0 : 12.0);

    // screen height অনুযায়ী item count
    final itemCount = ((screenHeight - kToolbarHeight) / (height + margin * 2)).ceil();

    return ListView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: height,
          width: maxWidth ?? double.infinity,
          margin: EdgeInsets.symmetric(vertical: margin, horizontal: margin),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
