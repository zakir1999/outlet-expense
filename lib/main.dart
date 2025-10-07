import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:outlet_expense/services/api_service.dart';

import 'Signup/bloc/signup_bloc.dart';

import 'menu/bloc/navigation_bloc.dart';
import 'router/router.dart'; // Make sure your GoRouter `router` is imported

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // SignupBloc provider
        BlocProvider<SignupBloc>(
          create: (context) => SignupBloc(ApiService()),
        ),

        // NavigationBloc provider for ScaffoldWithNavBar
        BlocProvider<NavigationBloc>(
          create: (context) => NavigationBloc(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'outlet-expense',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              appBarTheme: const AppBarTheme(
                backgroundColor: Color.fromARGB(255, 35, 59, 201),
                foregroundColor: Colors.white,
                elevation: 2,
              ),
            ),
            routerConfig: router, // Use the GoRouter config
          );
        },
      ),
    );
  }
}
