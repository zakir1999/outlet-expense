// import 'package:flutter/material.dart';
// import 'package:outlet_expense/Signup/view/sign_up_page1.dart';
// import 'package:outlet_expense/Signup/view/sign_up_screen.dart';
// import 'package:outlet_expense/login/view/login_screen.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(375, 812),
//       minTextAdapt: true,
//       builder: (context, child) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'Outlet Expense',
//           theme: ThemeData(primarySwatch: Colors.blue),
//           home: SignUpPage1(),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outlet_expense/Signup/view/home_page.dart';

import 'Signup/bloc/signup_bloc.dart';
import 'Signup/view/sign_up_page1.dart';
import 'services/api_service.dart';
import 'Signup/view/sign_up_page2.dart';
import 'Signup/view/sign_up_page3.dart';
import 'Signup/view/sign_up_page4.dart';
import 'Signup/view/sign_up_page5.dart';
import 'Signup/view/sign_up_page6.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupBloc(ApiService()),
      child: MaterialApp(
        title: 'Flutter Signup',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 2,
          ),
        ),
        initialRoute: '/signup/1',
        routes: {
          '/signup/1': (context) => SignupPage1(),
          '/signup/2': (context) => SignupPage2(),
          '/signup/3': (context) => SignupPage3(),
          '/signup/4': (context) => SignupPage4(),
          '/signup/5': (context) => SignupPage5(),
          '/signup/6': (context) => SignupPage6(),
          '/home': (context) => HomePage(),
        },
      ),
    );
  }
}
