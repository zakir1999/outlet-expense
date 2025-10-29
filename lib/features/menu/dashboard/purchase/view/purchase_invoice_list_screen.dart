import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outlet_expense/features/menu/dashboard/purchase/bloc/purchase_invoice_state.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/TextField.dart';
import '../../invoice/widget/invoice_card.dart';
import '../bloc/purchase_invoice_event.dart';
import '../../invoice/view/invoice_details_screen.dart';
import '../bloc/purchase_invoice_bloc.dart';

class PurchaseInvoiceListScreen extends StatelessWidget {
  const PurchaseInvoiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil
    ScreenUtil.init(
      context,
      designSize: const Size(360, 690), // base design size (mobile)
      minTextAdapt: true,
      splitScreenMode: true,
    );

    final bloc = context.read<PurchaseInvoiceBloc>();

    return Scaffold(
      appBar: AppBar(

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Purchase Invoice List',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.2,
      ),
      backgroundColor: const Color(0xFFF6F8FA),
      body: Column(
        children: [


          /// Sales / Purchase Toggle
          // BlocBuilder<PurchaseInvoiceBloc, PurchaseInvoiceState>(
          //   builder: (context, state) {
          //     String active = 'Pur';
          //     if (state is PurchaseInvoiceLoaded) active = state.activeType;
          //
          //     return Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 18.w),
          //       child: Row(
          //         children: [
          //           Expanded(
          //             child: ElevatedButton(
          //               style: ElevatedButton.styleFrom(
          //                 backgroundColor: active == 'Pur'
          //                     ? AppColors.primary
          //                     : Colors.white,
          //                 elevation: 3,
          //                 shadowColor: AppColors.primary,
          //                 shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(50.r),
          //                 ),
          //                 padding: EdgeInsets.symmetric(vertical: 12.h),
          //               ),
          //               onPressed: () => bloc.add(ChangeTypeFilter('Pur')),
          //               child: Text(
          //                 'Purchase',
          //                 style: TextStyle(
          //                   color: active == 'Pur'
          //                       ? AppColors.background
          //                       : AppColors.textDark,
          //                   fontWeight: FontWeight.w600,
          //                   fontSize: 16.sp,
          //                 ),
          //               ),
          //             ),
          //           ),
          //           SizedBox(width: 4.w),
          //           Expanded(
          //             child: ElevatedButton(
          //               style: ElevatedButton.styleFrom(
          //                 backgroundColor: active != 'Pur'
          //                     ? AppColors.primary
          //                     : Colors.white,
          //                 elevation: 3,
          //                 shadowColor: AppColors.primary,
          //                 shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(50.r),
          //                 ),
          //                 padding: EdgeInsets.symmetric(vertical: 12.h),
          //               ),
          //               onPressed: () => bloc.add(ChangeTypeFilter('Inv')),
          //               child: Text(
          //                 'Sales',
          //                 style: TextStyle(
          //                   color: active != 'Pur'
          //                       ? AppColors.background
          //                       : AppColors.textDark,
          //                   fontWeight: FontWeight.w600,
          //                   fontSize: 16.sp,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          // ),

          // SizedBox(height: 12.h),


          /// Search Field
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
            child: Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: const InputDecorationTheme(
                  prefixIconColor: Color(0xFF142EE4), // custom color
                ),
              ),
              child: CustomTextField(
                label: 'Search Invoice',
                hint: 'Search Invoice',
                prefixIcon: Icons.search,
                onChanged: (value) => bloc.add(SearchQueryChanged(value)),
                keyboardType: TextInputType.text,
                controller: null,
              ),
            ),
          ),

          SizedBox(height: 10.h),
          Expanded(
            child: BlocBuilder<PurchaseInvoiceBloc, PurchaseInvoiceState>(
              builder: (context, state) {
                if (state is PurchaseInvoiceLoading || state is PurchaseInvoiceInitial) {
                  return const Center(child: CircularProgressIndicator(color: Colors.grey,));
                } else if (state is PurchaseInvoiceError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  );
                } else if (state is PurchaseInvoiceLoaded) {
                  final invoices = state.visibleInvoices;
                  if (invoices.isEmpty) {
                    return Center(
                      child: Text(
                        'No Invoices Found',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    );
                  }
                  return NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 100) {
                        bloc.add(const FetchMorePurchaseInvoices());
                      }
                      return false;
                    },
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: invoices.length + 1,
                      cacheExtent: 100,
                      itemBuilder: (context, index) {
                        if (index < invoices.length) {
                          final inv = invoices[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        InvoiceDetailsScreen(invoiceId: inv.id),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(12.r),
                              child: InvoiceCard(
                                id: inv.id,
                                customerName: inv.customerName,
                                createdAt: inv.createdAt,
                                amount: inv.amount,
                              ),
                            ),
                          );
                        } else {
                          // ✅ Show loader when more data is loading
                          final hasMore = (state).hasMore;
                          if (hasMore) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Center(child: CircularProgressIndicator(color: Colors.grey,)),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }
                      },
                    ),
                  );

                }
                return const SizedBox.shrink();
              },
            ),
          ),


        ],
      ),
    );
  }
}
