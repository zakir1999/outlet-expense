import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:outlet_expense/core/api/api_client.dart';
import 'package:outlet_expense/features/dashboard/invoice/bloc/invoice_bloc.dart';
import 'package:outlet_expense/features/dashboard/invoice/repository/invoice_repository.dart';
import 'package:outlet_expense/features/dashboard/invoice/view/invoice_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/dashboard/invoice/bloc/invoice_event.dart';
import '../../features/login/view/login_screen.dart';
import '../../features/menu/view/cart_screen.dart';
import '../../features/menu/view/contact_screen.dart';
import '../../features/menu/view/dash_board.dart';
import '../../features/menu/view/payment_screen.dart';
import '../../features/menu/view/scaffold_with_nav_bar.dart';
import '../../features/Signup/view/sign_up_page1.dart';
import '../../features/Signup/view/sign_up_page2.dart';
import '../../features/Signup/view/sign_up_page3.dart';
import '../../features/Signup/view/sign_up_page4.dart';
import '../../features/Signup/view/sign_up_page5.dart';
import '../../features/Signup/view/sign_up_page6.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

// 1. ASYNCHRONOUS HELPER FUNCTION TO GET TOKEN
// We move the SharedPreferences logic into this function so it can be awaited.
Future<String?> _getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  // The redirect works fine because it is an async function
  redirect: (BuildContext context, GoRouterState state) async {
    final token = await _getToken(); // Use the helper function here
    final publicRoutes = ['/login', '/signup/1', '/signup/2', '/signup/3', '/signup/4', '/signup/5', '/signup/6'];

    final isLoggedIn = token != null;
    final isPublicRoute = publicRoutes.contains(state.matchedLocation);

    if (!isLoggedIn && !isPublicRoute) {
      return '/login';
    }

    if (isLoggedIn && state.matchedLocation == '/login') {
      return '/';
    }

    return null;
  },
  routes: <RouteBase>[
    // Login page
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),

    // Signup pages
    GoRoute(
      path: '/signup/1',
      builder: (context, state) =>  SignupPage1(),
    ),
    GoRoute(
      path: '/signup/2',
      builder: (context, state) =>  SignupPage2(),
    ),
    GoRoute(
      path: '/signup/3',
      builder: (context, state) =>  SignupPage3(),
    ),
    GoRoute(
      path: '/signup/4',
      builder: (context, state) => SignupPage4(),
    ),
    GoRoute(
      path: '/signup/5',
      builder: (context, state) =>  SignupPage5(),
    ),
    GoRoute(
      path: '/signup/6',
      builder: (context, state) =>  SignupPage6(),
    ),

    // Bottom NavBar + Home tabs
    StatefulShellRoute.indexedStack(
      builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/', // First tab: Profile/Dashboard
              // NOTE: Assuming ProfileScreen is a typo for DashboardScreen or similar in your structure
              builder: (context, state) => const DashBoard(), // Changed to DashboardScreen
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cart', // Second tab: Cart
              builder: (context, state) => const CartScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/contact', // Third tab: Contact
              builder: (context, state) => const ContactScreen(),
            ),
          ],
        ),
      ],
    ),

    // Payment page (outside nav bar)
    GoRoute(
      path: '/payment',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        return const PaymentScreen();
      },
    ),

    // 2. RECENT ORDERS ROUTE (UPDATED)
    GoRoute(
      path: '/recent-orders',
      builder: (context, state) {
        return BlocProvider(
          create: (context) => InvoiceBloc(
            repository: InvoiceRepository(
              apiClient: ApiClient(),
            ),
          )..add(FetchInvoices()),
          child: const InvoiceListScreen(),
        );
      },
    ),
  ],
);