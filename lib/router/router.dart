import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../login/view/login_screen.dart';
import '../menu/cart_screen.dart';
import '../menu/contact_screen.dart';
import '../menu/payment_screen.dart';
import '../menu/profile_screen.dart';
import '../menu/scaffold_with_nav_bar.dart';
import '../Signup/view/sign_up_page1.dart';
import '../Signup/view/sign_up_page2.dart';
import '../Signup/view/sign_up_page3.dart';
import '../Signup/view/sign_up_page4.dart';
import '../Signup/view/sign_up_page5.dart';
import '../Signup/view/sign_up_page6.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
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
