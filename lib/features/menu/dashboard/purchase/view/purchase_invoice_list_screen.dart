// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:outlet_expense/features/menu/dashboard/purchase/bloc/purchase_invoice_state.dart';
// import '../../../../../core/theme/app_colors.dart';
// import '../../../../../core/widgets/TextField.dart';
// import '../../invoice/widget/invoice_card.dart';
// import '../bloc/purchase_invoice_event.dart';
// import '../../invoice/view/invoice_details_screen.dart';
// import '../bloc/purchase_invoice_bloc.dart';
//
// class PurchaseInvoiceListScreen extends StatelessWidget {
//   const PurchaseInvoiceListScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Initialize ScreenUtil
//     ScreenUtil.init(
//       context,
//       designSize: const Size(360, 690), // base design size (mobile)
//       minTextAdapt: true,
//       splitScreenMode: true,
//     );
//
//     final bloc = context.read<PurchaseInvoiceBloc>();
//
//     return Scaffold(
//       appBar: AppBar(
//
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_sharp, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text(
//           'Purchase Invoice List',
//           style: TextStyle(
//             color: AppColors.textDark,
//             fontWeight: FontWeight.bold,
//             fontSize: 20.sp,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(color: Colors.black),
//         elevation: 0.2,
//       ),
//       backgroundColor: const Color(0xFFF6F8FA),
//       body: Column(
//         children: [
//
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
//             child: Theme(
//               data: Theme.of(context).copyWith(
//                 inputDecorationTheme: const InputDecorationTheme(
//                   prefixIconColor: Color(0xFF142EE4), // custom color
//                 ),
//               ),
//               child: CustomTextField(
//                 label: 'Search Invoice',
//                 hint: 'Search Invoice',
//                 prefixIcon: Icons.search,
//                 onChanged: (value) => bloc.add(SearchQueryChanged(value)),
//                 keyboardType: TextInputType.text,
//                 controller: null,
//               ),
//             ),
//           ),
//
//           SizedBox(height: 10.h),
//           Expanded(
//             child: BlocBuilder<PurchaseInvoiceBloc, PurchaseInvoiceState>(
//               builder: (context, state) {
//                 if (state is PurchaseInvoiceLoading || state is PurchaseInvoiceInitial) {
//                   return const Center(child: CircularProgressIndicator(color: Colors.grey,));
//                 } else if (state is PurchaseInvoiceError) {
//                   return Center(
//                     child: Text(
//                       state.message,
//                       style: TextStyle(fontSize: 14.sp),
//                     ),
//                   );
//                 } else if (state is PurchaseInvoiceLoaded) {
//                   final invoices = state.visibleInvoices;
//                   if (invoices.isEmpty) {
//                     return Center(
//                       child: Text(
//                         'No Invoices Found',
//                         style: TextStyle(fontSize: 14.sp),
//                       ),
//                     );
//                   }
//                   return NotificationListener<ScrollNotification>(
//                     onNotification: (scrollInfo) {
//                       if (scrollInfo.metrics.pixels >=
//                           scrollInfo.metrics.maxScrollExtent - 100) {
//                         bloc.add(const FetchMorePurchaseInvoices());
//                       }
//                       return false;
//                     },
//                     child: ListView.builder(
//                       physics: const BouncingScrollPhysics(),
//                       itemCount: invoices.length + 1,
//                       cacheExtent: 100,
//                       itemBuilder: (context, index) {
//                         if (index < invoices.length) {
//                           final inv = invoices[index];
//                           return Padding(
//                             padding: EdgeInsets.symmetric(vertical: 4.h),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         InvoiceDetailsScreen(invoiceId: inv.id),
//                                   ),
//                                 );
//                               },
//                               borderRadius: BorderRadius.circular(12.r),
//                               child: InvoiceCard(
//                                 id: inv.id,
//                                 customerName: inv.customerName,
//                                 createdAt: inv.createdAt,
//                                 amount: inv.amount,
//                               ),
//                             ),
//                           );
//                         } else {
//                           // ✅ Show loader when more data is loading
//                           final hasMore = (state).hasMore;
//                           if (hasMore) {
//                             return const Padding(
//                               padding: EdgeInsets.symmetric(vertical: 16.0),
//                               child: Center(child: CircularProgressIndicator(color: Colors.grey,)),
//                             );
//                           } else {
//                             return const SizedBox.shrink();
//                           }
//                         }
//                       },
//                     ),
//                   );
//
//                 }
//                 return const SizedBox.shrink();
//               },
//             ),
//           ),
//
//
//         ],
//       ),
//     );
//   }
// }
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

class PurchaseInvoiceListScreen extends StatefulWidget {
  const PurchaseInvoiceListScreen({super.key});

  @override
  State<PurchaseInvoiceListScreen> createState() =>
      _PurchaseInvoiceListScreenState();
}

class _PurchaseInvoiceListScreenState extends State<PurchaseInvoiceListScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isFetching = false; // ✅ prevent multiple API calls

  @override
  void initState() {
    super.initState();
    final bloc = context.read<PurchaseInvoiceBloc>();

    // ✅ initial fetch
    bloc.add( FetchPurchaseInvoices());

    // Scroll listener for pagination
    _scrollController.addListener(() {
      final state = bloc.state;
      if (state is PurchaseInvoiceLoaded &&
          state.hasMore &&
          !_isFetching &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100) {
        _isFetching = true;
        bloc.add(const FetchMorePurchaseInvoices());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil
    ScreenUtil.init(
      context,
      designSize: const Size(360, 690),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
            child: Theme(
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
          ),

          SizedBox(height: 10.h),
          Expanded(
            child: BlocBuilder<PurchaseInvoiceBloc, PurchaseInvoiceState>(
              builder: (context, state) {
                if (state is PurchaseInvoiceLoading ||
                    state is PurchaseInvoiceInitial) {
                  return const Center(
                      child: CircularProgressIndicator(color: Colors.grey));
                } else if (state is PurchaseInvoiceError) {
                  _isFetching = false; // ✅ reset flag on error
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  );
                } else if (state is PurchaseInvoiceLoaded) {
                  _isFetching = false; // ✅ reset flag after success
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
                    controller: _scrollController, // ✅ attach controller
                    physics: const BouncingScrollPhysics(),
                    itemCount: invoices.length + 1, // +1 for loader
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
                        // ✅ show bottom loader
                        if (state.hasMore) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.grey,
                                )),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }
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
