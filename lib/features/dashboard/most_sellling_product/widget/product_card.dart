import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/most_selling_model.dart';

class MostSellingCard extends StatefulWidget {
  final MostSellingProduct product;

  const MostSellingCard({super.key, required this.product});

  @override
  State<MostSellingCard> createState() => _MostSellingCardState();
}

class _MostSellingCardState extends State<MostSellingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
      lowerBound: 0.97,
      upperBound: 1.0,
    );

    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = const Color(0xFF4A6CF7);
    final secondaryColor = const Color(0xFF6C63FF);
    final cardBgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textPrimary = isDark ? Colors.white : Colors.black87;
    final textSecondary = isDark ? Colors.grey[400]! : Colors.grey[700]!;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _controller.reverse(),
        onTapUp: (_) => _controller.forward(),
        onTapCancel: () => _controller.forward(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(14.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Hero(
                  tag: widget.product.imageUrl,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14.r),
                    child: Image.network(
                      widget.product.imageUrl,
                      height: 80.h,
                      width: 80.w,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 80.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Icon(Icons.image_not_supported,
                            size: 40.sp,
                            color: isDark ? Colors.grey[500] : Colors.grey[700]),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        widget.product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 5.h),

                      // Category
                      Text(
                        '${widget.product.category} • ${widget.product.subCategory}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // Brand & Price Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Brand: ${widget.product.brand}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [primaryColor, secondaryColor],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              '৳${widget.product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),

                      // Stock Info
                      Row(
                        children: [
                          Icon(Icons.inventory_2_outlined,
                              color: secondaryColor, size: 16.sp),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              'Stock: ${widget.product.stock} ${widget.product.unit}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 12.5.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
