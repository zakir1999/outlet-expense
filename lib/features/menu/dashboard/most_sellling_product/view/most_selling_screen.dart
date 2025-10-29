// lib/features/most_selling/ui/most_selling_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/api/api_client.dart';
import '../bloc/most_selling_bloc.dart';
import '../bloc/most_selling_event.dart';
import '../bloc/most_selling_state.dart';
import '../model/most_selling_model.dart';
import '../repository/most_selling_repository.dart';
import '../widget/product_card.dart'; // adjust path to your ApiClient

class MostSellingScreen extends StatefulWidget {
  /// Option A: pass your app's ApiClient instance (preferred)
  final ApiClient? apiClient;

  /// Option B: if you don't pass an ApiClient, pass a navigatorKey that ApiClient needs.
  final GlobalKey<NavigatorState>? navigatorKey;

  const MostSellingScreen({super.key, this.apiClient, this.navigatorKey});

  @override
  State<MostSellingScreen> createState() => _MostSellingScreenState();
}

class _MostSellingScreenState extends State<MostSellingScreen> {
  late MostSellingBloc bloc;
  final TextEditingController _searchController = TextEditingController();
  List<MostSellingProduct> _allProducts = [];
  List<MostSellingProduct> _filtered = [];

  @override
  void initState() {
    super.initState();

    final ApiClient client = widget.apiClient ??
        ApiClient(navigatorKey: widget.navigatorKey ?? GlobalKey<NavigatorState>());

    final repo = MostSellingRepository(apiClient: client);
    bloc = MostSellingBloc(repo);

    // fetch data
    bloc.add(FetchMostSellingProducts());

    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() => _filtered = List.from(_allProducts));
      return;
    }

    final results = _allProducts.where((p) => p.name.toLowerCase().contains(q)).toList();
    setState(() => _filtered = results);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    bloc.close();
    super.dispose();
  }

  Widget _shimmerList() {
    return ListView.builder(
      itemCount: 6,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      itemBuilder: (_, __) => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 110.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_sharp, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),          backgroundColor: Colors.white,
          title: Text('Most Selling Products', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600,color: Colors.black)),
          centerTitle: true,
        ),
        body: BlocBuilder<MostSellingBloc, MostSellingState>(
          bloc: bloc,
          builder: (context, state) {
            if (state is MostSellingLoading || state is MostSellingInitial) {
              return _shimmerList();
            } else if (state is MostSellingLoaded) {
              _allProducts = state.allProducts;
              _filtered = _searchController.text.isEmpty ? List.from(state.filteredProducts) : _filtered;

              return RefreshIndicator(
                onRefresh: () async {
                  bloc.add(RefreshMostSellingProducts());
                },
                child: Column(
                  children: [
                Theme(
                data: Theme.of(context).copyWith(
                  inputDecorationTheme: const InputDecorationTheme(
                    prefixIconColor: Color(0xFF142EE4),
                  ),
                ),
                    child:
                    Padding(
                      padding: EdgeInsets.fromLTRB(25.w, 10.h, 25.w, 10.h),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search product',
                          prefixIcon: Icon(Icons.search, size: 20.sp),
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                        ),
                      ),
                    ),
                ),
                    Expanded(
                      child: _filtered.isEmpty
                          ? Center(child: Text('No products found', style: TextStyle(fontSize: 14.sp)))
                          : ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                        itemBuilder: (context, index) => MostSellingCard(product: _filtered[index]),
                        separatorBuilder: (_, __) => SizedBox(height: 8.h),
                        itemCount: _filtered.length,
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is MostSellingError) {
              return Center(child: Text('Error: ${state.message}', style: TextStyle(fontSize: 14.sp, color: Colors.red)));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
