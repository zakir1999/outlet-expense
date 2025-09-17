import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:outlet_expense/Signup/bloc/sign_up_bloc.dart';

import '../../Custom-Component/Submit_Button.dart';
import '../../Custom-Component/TextField.dart';
import './StepOutLetType.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpBloc(),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatelessWidget {
  const _SignUpView();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final horizontalPadding = screenWidth < 600 ? 16.0 : 32.0;
    final verticalPadding = screenWidth < 600 ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Sign Up",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Times New Roman',
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: BlocProvider(
        create: (_) => SignUpBloc(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                top: screenHeight * 0.05,
                left: horizontalPadding,
                right: horizontalPadding,
                bottom: verticalPadding,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - verticalPadding * 2,
                ),
                child: IntrinsicHeight(
                  child: Center(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth < 600 ? double.infinity : 600,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: BlocListener<SignUpBloc, SignUpState>(
                          listener: (context, state) {
                            if (state.status == SignUpStatus.success) {
                              Navigator.pushReplacementNamed(context, "/home");
                            }
                            if (state.status == SignUpStatus.failure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Registration failed"),
                                ),
                              );
                            }
                          },
                          child: BlocBuilder<SignUpBloc, SignUpState>(
                            builder: (context, state) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Gap(20),
                                          if (state.step == 1)
                                            _StepUserOutlet(),
                                          if (state.step == 2) StepOutletType(),
                                          if (state.step == 3)
                                            _StepEmailPhone(),
                                          if (state.step == 4) _StepPassword(),
                                          if (state.step == 5) _StepPin(),
                                          if (state.step == 6)
                                            _StepConfirmPin(),
                                          const Gap(30),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                              bottom: 16,
                                            ),
                                            child: BlocBuilder<SignUpBloc, SignUpState>(
                                              builder: (context, state) {
                                                return SizedBox(
                                                  width: double.infinity,
                                                  child: CustomButton(
                                                    text: state.step < 6
                                                        ? "Next"
                                                        : "Finish",
                                                    isLoading:
                                                        state.status ==
                                                        SignUpStatus.loading,
                                                    onPressed:
                                                        state.status ==
                                                            SignUpStatus.loading
                                                        ? null
                                                        : () {
                                                            if (state.step <
                                                                6) {
                                                              context
                                                                  .read<
                                                                    SignUpBloc
                                                                  >()
                                                                  .add(
                                                                    NextStep(),
                                                                  );
                                                            } else {
                                                              context
                                                                  .read<
                                                                    SignUpBloc
                                                                  >()
                                                                  .add(
                                                                    SubmitSignUp(),
                                                                  );
                                                            }
                                                          },
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StepUserOutlet extends StatelessWidget {
  const _StepUserOutlet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Provide us your & \n Store Name',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
        ),
        Gap(10),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Provide us your & Store Name',
            style: TextStyle(
              fontSize: 16,
              color: const Color.fromARGB(255, 97, 96, 96),
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Gap(10),
        CustomTextField(
          label: "Woner name",
          hint: 'Woner name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Woner name can't be empty";
            }
          },
          keyboardType: TextInputType.text,
          onChanged: (value) {
            context.read<SignUpBloc>().add(UserNameChanged(value));
          },
        ),
        const Gap(20),
        CustomTextField(
          label: "Outlet name",
          hint: 'Outlet name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Outlet name can't be empty";
            }
          },
          keyboardType: TextInputType.text,
          onChanged: (value) {
            context.read<SignUpBloc>().add(UserNameChanged(value));
          },
        ),
      ],
    );
  }
}

class _StepEmailPhone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: "Email"),
          onChanged: (v) => context.read<SignUpBloc>().add(EmailChanged(v)),
        ),
        const Gap(16),
        TextFormField(
          decoration: const InputDecoration(labelText: "Phone"),
          onChanged: (v) => context.read<SignUpBloc>().add(PhoneChanged(v)),
        ),
      ],
    );
  }
}

class _StepPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          obscureText: true,
          decoration: const InputDecoration(labelText: "Password"),
          onChanged: (v) => context.read<SignUpBloc>().add(PasswordChanged(v)),
        ),
        const Gap(16),
        TextFormField(
          obscureText: true,
          decoration: const InputDecoration(labelText: "Confirm Password"),
          onChanged: (v) =>
              context.read<SignUpBloc>().add(ConfirmPasswordChanged(v)),
        ),
      ],
    );
  }
}

class _StepPin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      maxLength: 6,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(labelText: "6 Digit Pin"),
      onChanged: (v) => context.read<SignUpBloc>().add(PinChanged(v)),
    );
  }
}

class _StepConfirmPin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      maxLength: 6,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(labelText: "Confirm 6 Digit Pin"),
      onChanged: (v) => context.read<SignUpBloc>().add(ConfirmPinChanged(v)),
    );
  }
}
