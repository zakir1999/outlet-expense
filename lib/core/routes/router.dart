import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:outlet_expense/features/menu/dashboard/purchase/bloc/purchase_invoice_bloc.dart';
import 'package:outlet_expense/features/menu/dashboard/purchase/bloc/purchase_invoice_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/menu/dashboard/invoice/bloc/invoice_event.dart';
import '../../features/menu/dashboard/most_sellling_product/bloc/most_selling_bloc.dart';
import '../../features/menu/dashboard/most_sellling_product/bloc/most_selling_event.dart';
import '../../features/menu/dashboard/most_sellling_product/repository/most_selling_repository.dart';
import '../../features/menu/dashboard/most_sellling_product/view/most_selling_screen.dart';
import '../../features/menu/dashboard/purchase/repository/purchase_repository.dart';
import '../../features/menu/dashboard/purchase/view/purchase_invoice_list_screen.dart';
import '../../features/login/view/login_screen.dart';
import '../../features/menu/report/imei_serial_report/view/imei_serial_report_screen.dart';
import '../../features/menu/report/production_stock_report/bloc/production_stock_bloc.dart';
import '../../features/menu/report/production_stock_report/view/production_stock_screen.dart';
import '../../features/menu/report/category_sales_report/view/sales_report_screen.dart';
import '../../features/menu/report/view/report_screen.dart';
import '../../features/menu/view/contact_screen.dart';
import '../../features/menu/view/dash_board.dart';
import '../../features/menu/view/payment_screen.dart';
import '../../features/menu/view/scaffold_with_nav_bar.dart';
import '../../features/menu/dashboard/invoice/bloc/invoice_bloc.dart';
import '../../features/menu/dashboard/invoice/repository/invoice_repository.dart';
import '../../features/menu/dashboard/invoice/view/invoice_list_screen.dart';
import '../../features/Signup/view/sign_up_page1.dart';
import '../../features/Signup/view/sign_up_page2.dart';
import '../../features/Signup/view/sign_up_page3.dart';
import '../../features/Signup/view/sign_up_page4.dart';
import '../../features/Signup/view/sign_up_page5.dart';
import '../../features/Signup/view/sign_up_page6.dart';

import '../api/api_client.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

// Helper function to get stored token
Future<String?> _getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  redirect: (BuildContext context, GoRouterState state) async {
    final token = await _getToken();
    final publicRoutes = [
      '/login',
      '/signup/1',
      '/signup/2',
      '/signup/3',
      '/signup/4',
      '/signup/5',
      '/signup/6'
    ];

    final isLoggedIn = token != null;
    final isPublicRoute = publicRoutes.contains(state.matchedLocation);

    if (!isLoggedIn && !isPublicRoute) return '/login';
    if (isLoggedIn && state.matchedLocation == '/login') return '/';
    return null;
  },
  routes: <RouteBase>[
    // Login
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) => const LoginScreen(),
    ),

    // Signup pages
    GoRoute(path: '/signup/1', builder: (_, __) => SignupPage1()),
    GoRoute(path: '/signup/2', builder: (_, __) => SignupPage2()),
    GoRoute(path: '/signup/3', builder: (_, __) => SignupPage3()),
    GoRoute(path: '/signup/4', builder: (_, __) => SignupPage4()),
    GoRoute(path: '/signup/5', builder: (_, __) => SignupPage5()),
    GoRoute(path: '/signup/6', builder: (_, __) => SignupPage6()),

    // Bottom NavBar + Home tabs
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ScaffoldWithNavBar(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (_, __) => const DashBoard()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/report', builder: (_, __) => const ReportScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/contact', builder: (_, __) => const ContactScreen()),
          ],
        ),
      ],
    ),

    // Payment (outside bottom nav)
    GoRoute(
      path: '/payment',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const PaymentScreen(),
    ),
    // Recent Orders (Invoice)
    GoRoute(
      path: '/recent-orders',
      builder: (context, state) {
        return BlocProvider(
          create: (context) => InvoiceBloc(
            repository: InvoiceRepository(
              apiClient: ApiClient(navigatorKey: _rootNavigatorKey),
            ),
          )..add(FetchInvoices()),
          child: const InvoiceListScreen(),
        );
      },
    ),
    GoRoute(
      path: '/purchase-invoice',
      builder: (context, state) {
        return BlocProvider(
          create: (context) => PurchaseInvoiceBloc(
            repository: PurchaseInvoiceRepository(
              apiClient: ApiClient(navigatorKey: _rootNavigatorKey),
            ),
          )..add(FetchPurchaseInvoices()),
          child: const PurchaseInvoiceListScreen(),
        );
      },
    ),
    GoRoute(
      path: '/most-selling',
      builder: (context, state) {
        return BlocProvider(
          create: (context) => MostSellingBloc(
            MostSellingRepository(
              apiClient: ApiClient(navigatorKey: _rootNavigatorKey),
            ),
          )..add(FetchMostSellingProducts()),
          child: const MostSellingScreen(),
        );
      },
    ),
    GoRoute(
      path: '/category-sale-report',
      builder: (context, state) {
        return SalesReportScreen(
          navigatorKey: _rootNavigatorKey,
        );
      },
    ),
    GoRoute(
      path: '/product-stock-report',
      builder: (context, state) {
        final apiClient = ApiClient(navigatorKey: _rootNavigatorKey);
        return BlocProvider(
          create: (_) => ProductionStockBloc(navigatorKey: _rootNavigatorKey),
          child: ProductionStockScreen(
            navigatorKey: _rootNavigatorKey,
            apiClient: apiClient,
          ),
        );
      },
    ),

    GoRoute(
      path: '/imei-serial-report',
      builder: (context, state) {
        final apiClient = ApiClient(navigatorKey: _rootNavigatorKey); // or use dependency injection
        return ImeiSerialReportScreen(
          navigatorKey: _rootNavigatorKey,
          apiClient: apiClient,
        );
      },
    ),
  ],
);
