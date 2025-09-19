import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:outlet_expense/Signup/view/pass_confirm_password.dart';
import '../../Widgets/custom_button.dart';
import '../../Widgets/textfield.dart';
import '../../login/view/login_screen.dart';
import '../bloc/sign_up_bloc.dart';

class StepUserOutletWrapper extends StatelessWidget {
  const StepUserOutletWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listenWhen: (previous, current) => previous.step != current.step,
      listener: (context, state) {
        if (state.step == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const StepPasswordWrapper()),
          );
        }
      },
      child: const _StepUserOutlet(),
    );
  }
}

class _StepUserOutlet extends StatelessWidget {
  const _StepUserOutlet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Provide us your & \nStore Name',
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Owner name can't be empty";
              }
              return null;
            },
            keyboardType: TextInputType.text,
            onChanged: (value) {
              context.read<SignUpBloc>().add(UserNameChanged(value));
            },
          ),
          SizedBox(height: 20.h),
          CustomTextField(
            label: "Outlet name",
            hint: 'Outlet name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Outlet name can't be empty";
              }
              return null;
            },
            keyboardType: TextInputType.text,
            onChanged: (value) {
              context.read<SignUpBloc>().add(OutletNameChanged(value));
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
    );
  }
}
