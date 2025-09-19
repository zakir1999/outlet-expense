import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../Signup/view/StepOutLetType.dart';
import '../../login/view/login_screen.dart';
import '../../Widgets/Password.dart';
import '../../Widgets/custom_button.dart';

import '../bloc/sign_up_bloc.dart';

class StepPasswordWrapper extends StatelessWidget {
  const StepPasswordWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listenWhen: (previous, current) => previous.step != current.step,
      listener: (context, state) {
        if (state.step == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const StepOutletType()),
          );
        }
      },
      child: const _StepPassword(),
    );
  }
}

class _StepPassword extends StatelessWidget {
  const _StepPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordFocusNode = FocusNode();
    final confirmPasswordFocusNode = FocusNode();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set Your Password',
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.h),
          Text(
            'Choose a strong password for your account',
            style: TextStyle(fontSize: 16.sp, color: Colors.black54),
          ),
          SizedBox(height: 20.h),
          BlocBuilder<SignUpBloc, SignUpState>(
            buildWhen: (previous, current) =>
                previous.password != current.password,
            builder: (context, state) {
              return CustomPasswordField(
                label: "Password",
                hint: "Password",
                focusNode: passwordFocusNode,
                onChanged: (value) {
                  context.read<SignUpBloc>().add(PasswordChanged(value));
                },
              );
            },
          ),
          SizedBox(height: 20.h),
          BlocBuilder<SignUpBloc, SignUpState>(
            buildWhen: (previous, current) =>
                previous.confirmPassword != current.confirmPassword,
            builder: (context, state) {
              return CustomPasswordField(
                label: "Confirm Password",
                hint: "Confirm Password",
                focusNode: confirmPasswordFocusNode,
                onChanged: (value) {
                  context.read<SignUpBloc>().add(ConfirmPasswordChanged(value));
                },
              );
            },
          ),
          Gap(30.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: CustomButton(
              text: 'Next',
              onPressed: () {
                context.read<SignUpBloc>().add(NextStep());
              },
            ),
          ),
          Gap(10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account? ",
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
                  'Sign',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: Color.fromARGB(255, 35, 59, 201),
                    decorationThickness: 2,
                    fontSize: 14.sp,
                    color: Color.fromARGB(255, 35, 59, 201),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
