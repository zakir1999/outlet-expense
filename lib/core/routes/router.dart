import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


import 'package:shared_preferences/shared_preferences.dart';

import '../../features/login/view/login_screen.dart';
import '../../features/menu/view/cart_screen.dart';
import '../../features/menu/view/contact_screen.dart';
import '../../features/menu/view/payment_screen.dart';
import '../../features/menu/view/dash_board.dart';
import '../../features/menu/view/scaffold_with_nav_bar.dart';
import '../../features/Signup/view/sign_up_page1.dart';
import '../../features/Signup/view/sign_up_page2.dart';
import '../../features/Signup/view/sign_up_page3.dart';
import '../../features/Signup/view/sign_up_page4.dart';
import '../../features/Signup/view/sign_up_page5.dart';
import '../../features/Signup/view/sign_up_page6.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  redirect: (BuildContext context, GoRouterState state) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
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
              path: '/', // First tab: Profile
              builder: (context, state) => const ProfileScreen(),
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
  ],
);
