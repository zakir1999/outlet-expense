
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/TextField.dart';
import '../bloc/invoice_bloc.dart';
import '../bloc/invoice_event.dart';
import '../bloc/invoice_state.dart';
import '../widget/invoice_card.dart';
import 'invoice_details_screen.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<InvoiceBloc>();

    // ✅ initial fetch
    bloc.add( const FetchMoreInvoices());

    _scrollController.addListener(() {
      final state = bloc.state;
      if (state is InvoiceLoaded &&
          state.hasMore &&
          !_isFetching &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100) {
        _isFetching = true;
        bloc.add(const FetchMoreInvoices());
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
    final bloc = context.read<InvoiceBloc>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
            SizedBox(height: 5.h),

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

            SizedBox(height: 5.h),

            // --- Invoice List ---
            Expanded(
              child: BlocBuilder<InvoiceBloc, InvoiceState>(
                builder: (context, state) {
                  if (state is InvoiceLoading || state is InvoiceInitial) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.grey),
                    );
                  } else if (state is InvoiceError) {
                    _isFetching = false; // ✅ reset fetching on error
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    );
                  } else if (state is InvoiceLoaded) {
                    _isFetching = false; // ✅ reset fetching after success
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
                      itemCount: invoices.length + 1, // +1 for bottom loader
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
                          if (state.hasMore) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.grey,
                                ),
                              ),
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
      ),
    );
  }
}

