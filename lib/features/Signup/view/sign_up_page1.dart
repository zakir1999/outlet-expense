import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/textfield.dart';

import '../../../core/widgets/next_button.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../login/view/login_screen.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/signup_event.dart';
import '../bloc/signup_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupPage1 extends StatefulWidget {
  const SignupPage1({super.key});

  @override
  _SignupPage1State createState() => _SignupPage1State();
}

class _SignupPage1State extends State<SignupPage1> {
  final _wonerNameController = TextEditingController();
  final _outletNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final signupBloc = context.read<SignupBloc>();
    _wonerNameController.text = signupBloc.currentData.ownerName;
    _outletNameController.text = signupBloc.currentData.outletName;

    _wonerNameController.addListener(() {
      signupBloc.add(UpdateWonerName(_wonerNameController.text));
    });

    _outletNameController.addListener(() {
      signupBloc.add(UpdateOutletName(_outletNameController.text));
    });
  }

  @override
  void dispose() {
    _wonerNameController.dispose();
    _outletNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(showBackButton: false),
      body: BlocBuilder<SignupBloc, SignupState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30.h),
                  Text(
                    'Provide us your & \nStore Name',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Provide us your & Store Name',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color.fromARGB(255, 97, 96, 96),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    label: "Owner name",
                    hint: 'Owner name',
                    controller: _wonerNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Owner name can't be empty";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    hint: "Outlet name",
                    label: "Outlet name",
                    controller: _outletNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter outlet name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 50.h),
                  NextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.push('/signup/2');
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
