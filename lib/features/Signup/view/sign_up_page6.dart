import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/widgets/common_app_bar.dart';
import '../../../core/widgets/next_button.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/signup_event.dart';
import '../bloc/signup_state.dart';

class SignupPage6 extends StatefulWidget {
  @override
  _SignupPage6State createState() => _SignupPage6State();
}

class _SignupPage6State extends State<SignupPage6> {
  final _confirmPinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final signupBloc = context.read<SignupBloc>();
    _confirmPinController.text = signupBloc.currentData.confirmPin;

    _confirmPinController.addListener(() {
      signupBloc.add(UpdateConfirmPin(_confirmPinController.text));
    });
  }

  @override
  void dispose() {
    _confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: SafeArea(
        child: BlocConsumer<SignupBloc, SignupState>(
          listener: (context, state) {
            if (state is SignupSuccess) {
              // ✅ Navigate to home after successful pin submission
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('PIN set successfully!'),
                  backgroundColor: Color.fromARGB(255, 86, 76, 175),
                ),
              );
              context.go('/home');
            } else if (state is SignupError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.error}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is SignupSubmitting;

            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 20.h,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 30.h),
                            Text(
                              'Confirm PIN',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Please confirm your 6-digit PIN',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 40.h),

                            Center(
                              child: SizedBox(
                                width: 0.85.sw,
                                child: PinCodeTextField(
                                  appContext: context,
                                  controller: _confirmPinController,
                                  length: 6,
                                  obscureText: true,
                                  animationType: AnimationType.fade,
                                  keyboardType: TextInputType.number,
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.underline,
                                    fieldHeight: 55.h,
                                    fieldWidth: 45.w,
                                    inactiveColor: Colors.grey,
                                    selectedColor: Colors.blue,
                                    activeColor: Colors.blue,
                                  ),
                                  cursorColor: Colors.black,
                                  enableActiveFill: false,
                                  onChanged: (value) {
                                    context
                                        .read<SignupBloc>()
                                        .add(UpdateConfirmPin(value));
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please confirm PIN";
                                    }
                                    if (value.length != 6) {
                                      return "PIN must be 6 digits";
                                    }
                                    final signupBloc =
                                    context.read<SignupBloc>();
                                    if (value != signupBloc.currentData.pin) {
                                      return "PINs do not match";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            Gap(20.h),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: 20.h,
                                top: 40.h,
                              ),
                              child: NextButton(
                                text: 'Continue',
                                isLoading: isLoading,
                                onPressed: isLoading
                                    ? null
                                    : () {
                                  if (_formKey.currentState!.validate()) {
                                    context
                                        .read<SignupBloc>()
                                        .add(SubmitPinEvent());
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
