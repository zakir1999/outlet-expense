import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/most_selling_model.dart';

class MostSellingCard extends StatelessWidget {
  final MostSellingProduct product;

  const MostSellingCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                product.imageUrl,
                height: 70.h,
                width: 70.w,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.medication, size: 60.sp, color: Colors.grey),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.sp)),
                  SizedBox(height: 4.h),
                  Text('${product.category} • ${product.subCategory}',
                      style: TextStyle(fontSize: 13.sp)),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Brand: ${product.brand}',
                          style: TextStyle(fontSize: 13.sp)),
                      Text('৳${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14.sp)),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text('Stock: ${product.stock} ${product.unit}',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
