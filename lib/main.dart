import 'package:flutter/material.dart';
import 'package:outlet_expense/Signup/view/sign_up_screen.dart';
import 'package:outlet_expense/login/view/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Outlet Expense',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
    );
  }
}
