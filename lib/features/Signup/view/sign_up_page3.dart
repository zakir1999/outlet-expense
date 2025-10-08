import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/textfield.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../core/widgets/next_button.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/signup_event.dart';
import '../bloc/signup_state.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupPage3 extends StatefulWidget {
  @override
  _SignupPage3State createState() => _SignupPage3State();
}

class _SignupPage3State extends State<SignupPage3> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final signupBloc = context.read<SignupBloc>();
    _emailController.text = signupBloc.currentData.email;
    _phoneController.text = signupBloc.currentData.phone;

    _emailController.addListener(() {
      signupBloc.add(UpdateEmail(_emailController.text));
    });

    _phoneController.addListener(() {
      signupBloc.add(UpdatePhoneNumber(_phoneController.text));
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
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
                  const SizedBox(height: 30),
                  const Text(
                    'Provide us your \nContact Information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'For create a store for you, and keep track your expense for you.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                  CustomTextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    label: 'Email',
                    hint: 'Email',

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email address';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  Gap(20.h),
                  CustomTextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    label: 'Phone Number',
                    hint: 'Phone Number',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone number';
                      }
                      if (value.length < 11) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  Gap(10.h),
                  NextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.push('/signup/4');
                      }
                    },
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
