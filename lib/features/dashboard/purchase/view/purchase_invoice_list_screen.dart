import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outlet_expense/features/dashboard/purchase/bloc/purchase_invoice_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/TextField.dart';
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
        title: Text(
          'Invoice List',
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
          SizedBox(height: 10.h),

          /// Sales / Purchase Toggle





          BlocBuilder<PurchaseInvoiceBloc, PurchaseInvoiceState>(
            builder: (context, state) {
              String active = 'Inv';
              if (state is PurchaseInvoiceLoaded) active = state.activeType;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: active == 'Inv'
                              ? AppColors.primary
                              : Colors.white,
                          elevation: 3,
                          shadowColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        onPressed: () => bloc.add(ChangeTypeFilter('Inv')),
                        child: Text(
                          'Sales',
                          style: TextStyle(
                            color: active == 'Inv'
                                ? AppColors.background
                                : AppColors.textDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: active == 'Pur'
                              ? AppColors.primary
                              : Colors.white,
                          elevation: 3,
                          shadowColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        onPressed: () => bloc.add(ChangeTypeFilter('Pur')),
                        child: Text(
                          'Purchase',
                          style: TextStyle(
                            color: active == 'Pur'
                                ? AppColors.background
                                : AppColors.textDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          SizedBox(height: 12.h),

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

          /// Invoice List
          Expanded(
            child: BlocBuilder<PurchaseInvoiceBloc, PurchaseInvoiceState>(
              builder: (context, state) {
                if (state is PurchaseInvoiceLoading ||
                    state is PurchaseInvoiceInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PurchaseInvoiceError) {
                  return Center(child: Text(state.message));
                } else if (state is PurchaseInvoiceLoaded) {
                  final invoices = state.visibleInvoices;
                  if (invoices.isEmpty) {
                    return const Center(child: Text('No Invoices Found'));
                  }
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    cacheExtent: 200,
                    itemCount: invoices.length,
                    itemBuilder: (context, index) {
                      final inv = invoices[index];
                      return InkWell(
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
                      );
                    },
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
