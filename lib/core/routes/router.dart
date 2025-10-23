import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/dashboard/invoice/bloc/invoice_event.dart';
import '../../features/login/view/login_screen.dart';
import '../../features/menu/view/cart_screen.dart';
import '../../features/menu/view/contact_screen.dart';
import '../../features/menu/view/dash_board.dart';
import '../../features/menu/view/payment_screen.dart';
import '../../features/menu/view/scaffold_with_nav_bar.dart';
import '../../features/dashboard/invoice/bloc/invoice_bloc.dart';
import '../../features/dashboard/invoice/repository/invoice_repository.dart';
import '../../features/dashboard/invoice/view/invoice_list_screen.dart';
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
            GoRoute(path: '/cart', builder: (_, __) => const CartScreen()),
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
  ],
);
