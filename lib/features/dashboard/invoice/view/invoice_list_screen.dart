import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/TextField.dart';
import '../bloc/invoice_bloc.dart';
import '../bloc/invoice_event.dart';
import '../bloc/invoice_state.dart';
import '../widget/invoice_card.dart';
import 'invoice_details_screen.dart';

class InvoiceListScreen extends StatelessWidget {
  const InvoiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<InvoiceBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Invoice List',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.3,
      ),
      backgroundColor: const Color(0xFFF6F8FA),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          children: [
            // --- Toggle Buttons (Sales / Purchase) ---
            BlocBuilder<InvoiceBloc, InvoiceState>(
              builder: (context, state) {
                String active = 'Inv';
                if (state is InvoiceLoaded) active = state.activeType;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(5.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: active == 'Inv'
                                ? AppColors.primary
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.r),
                            ),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                          ),
                          onPressed: () => bloc.add(ChangeTypeFilter('Inv')),
                          child: Text(
                            'Sales',
                            style: TextStyle(
                              color: active == 'Inv'
                                  ? AppColors.background
                                  : AppColors.textDark,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: active == 'Pur'
                                ? AppColors.primary
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.r),
                            ),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                          ),
                          onPressed: () => bloc.add(ChangeTypeFilter('Pur')),
                          child: Text(
                            'Purchase',
                            style: TextStyle(
                              color: active == 'Pur'
                                  ? AppColors.background
                                  : AppColors.textDark,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: 16.h),

            // --- Search Bar ---
            Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: const InputDecorationTheme(
                  prefixIconColor: Color(0xFF142EE4),
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

            SizedBox(height: 14.h),

            // --- Invoice List ---
            Expanded(
              child: BlocBuilder<InvoiceBloc, InvoiceState>(
                builder: (context, state) {
                  if (state is InvoiceLoading || state is InvoiceInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is InvoiceError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    );
                  } else if (state is InvoiceLoaded) {
                    final invoices = state.visibleInvoices;
                    if (invoices.isEmpty) {
                      return Center(
                        child: Text(
                          'No Invoices Found',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      );
                    }
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: invoices.length,
                      itemBuilder: (context, index) {
                        final inv = invoices[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InvoiceDetailsScreen(
                                    invoiceId: inv.id,
                                  ),
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
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
