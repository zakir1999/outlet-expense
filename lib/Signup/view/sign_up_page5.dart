import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Widgets/common_app_bar.dart';
import '../../Widgets/next_button.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/signup_event.dart';
import '../bloc/signup_state.dart';

class SignupPage5 extends StatefulWidget {
  @override
  _SignupPage5State createState() => _SignupPage5State();
}

class _SignupPage5State extends State<SignupPage5> {
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final signupBloc = context.read<SignupBloc>();
    _pinController.text = signupBloc.currentData.pin;

    _pinController.addListener(() {
      signupBloc.add(UpdatePin(_pinController.text));
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: SafeArea(
        child: BlocBuilder<SignupBloc, SignupState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h),
                    Text(
                      'Create PIN',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Create a 6-digit PIN for quick access to your account',
                      style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                    ),
                    SizedBox(height: 40.h),

                    /// ✅ Responsive PIN input
                    Center(
                      child: SizedBox(
                        width: 0.85.sw, // takes 85% of screen width
                        child: PinCodeTextField(
                          appContext: context,
                          controller: _pinController,
                          length: 6,
                          obscureText: true,
                          animationType: AnimationType.fade,
                          keyboardType: TextInputType.number,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape
                                .underline, // ✅ removes square box, uses underline
                            borderRadius: BorderRadius.circular(0),
                            fieldHeight: 55.h,
                            fieldWidth: 45.w,
                            activeFillColor: Colors.transparent,
                            selectedFillColor: Colors.transparent,
                            inactiveFillColor: Colors.transparent,
                            inactiveColor: Colors.grey,
                            selectedColor: Colors.blue,
                            activeColor: Colors.blue,
                          ),
                          cursorColor: Colors.black,
                          enableActiveFill: false, // ✅ underline mode
                          onChanged: (value) {
                            context.read<SignupBloc>().add(UpdatePin(value));
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter PIN";
                            }
                            if (value.length != 6) {
                              return "PIN must be 6 digits";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),

                    /// ✅ Button stays at bottom with spacing
                    NextButton(
                      text: 'Continue',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pushNamed(context, '/signup/6');
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
