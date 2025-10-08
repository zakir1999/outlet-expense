import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/textfield.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../core/widgets/next_button.dart';
import '../../login/view/login_screen.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/signup_event.dart';
import '../bloc/signup_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupPage4 extends StatefulWidget {
  @override
  _SignupPage4State createState() => _SignupPage4State();
}

class _SignupPage4State extends State<SignupPage4> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    final signupBloc = context.read<SignupBloc>();
    _passwordController.text = signupBloc.currentData.password;
    _confirmPasswordController.text = signupBloc.currentData.confirmPassword;

    _passwordController.addListener(() {
      signupBloc.add(UpdatePassword(_passwordController.text));
    });

    _confirmPasswordController.addListener(() {
      signupBloc.add(UpdateConfirmPassword(_confirmPasswordController.text));
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: BlocBuilder<SignupBloc, SignupState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30.h),
                  Text(
                    'Set up password For \n secure your account',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'For createa store for you,and keep trace your expense for you.',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                  CustomTextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    label: 'Password ',
                    hint: 'Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    label: 'Confirm Password',
                    hint: 'Confirm password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 40.h),
                  NextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.push('/signup/5');
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Color.fromARGB(255, 35, 59, 201),
                            decorationThickness: 2,
                            fontSize: 14,
                            color: Color.fromARGB(255, 35, 59, 201),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
