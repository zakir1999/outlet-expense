import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:outlet_expense/Signup/bloc/sign_up_bloc.dart';

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
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: BlocListener<SignUpBloc, SignUpState>(
              listener: (context, state) {
                if (state.status == SignUpStatus.success) {
                  Navigator.pushReplacementNamed(context, "/home");
                }
                if (state.status == SignUpStatus.failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Registration failed")),
                  );
                }
              },
              child: BlocBuilder<SignUpBloc, SignUpState>(
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Gap(20),
                              if (state.step == 1) _StepUserOutlet(),
                              if (state.step == 2) _StepOutletType(),
                              if (state.step == 3) _StepEmailPhone(),
                              if (state.step == 4) _StepPassword(),
                              if (state.step == 5) _StepPin(),
                              if (state.step == 6) _StepConfirmPin(),
                              const Gap(20),
                            ],
                          ),
                        ),
                      ),

                      // Bottom Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (state.step > 1)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<SignUpBloc>().add(
                                      PreviousStep(),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 6,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      105,
                                      105,
                                      105,
                                    ),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text(
                                    "Back",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: BlocBuilder<SignUpBloc, SignUpState>(
                                builder: (context, state) {
                                  return SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed:
                                          state.status == SignUpStatus.loading
                                          ? null
                                          : () {
                                              if (state.step < 6) {
                                                context.read<SignUpBloc>().add(
                                                  NextStep(),
                                                );
                                              } else {
                                                context.read<SignUpBloc>().add(
                                                  SubmitSignUp(),
                                                );
                                              }
                                            },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 6,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          35,
                                          59,
                                          201,
                                        ),
                                        foregroundColor: Colors.white,
                                      ),
                                      child:
                                          state.status == SignUpStatus.loading
                                          ? const SizedBox(
                                              height: 22,
                                              width: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Text(
                                              state.step < 6
                                                  ? "Next"
                                                  : "Finish",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
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
        TextFormField(
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: 'User Name',
            hintText: 'Enter your name',
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 236, 239, 241),
                width: 2,
              ),
            ),
          ),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          onChanged: (value) {
            context.read<SignUpBloc>().add(UserNameChanged(value));
          },
        ),
        const Gap(16),
        TextFormField(
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: 'Outlet Name',
            hintText: 'Enter outlet name',
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 236, 239, 241),
                width: 2,
              ),
            ),
          ),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          onChanged: (value) {
            context.read<SignUpBloc>().add(OutletNameChanged(value));
          },
        ),
      ],
    );
  }
}

class _StepOutletType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: "Outlet Type"),
      items: const [
        DropdownMenuItem(value: "Shop", child: Text("Shop")),
        DropdownMenuItem(value: "Restaurant", child: Text("Restaurant")),
        DropdownMenuItem(value: "Other", child: Text("Other")),
      ],
      onChanged: (v) {
        if (v != null) {
          context.read<SignUpBloc>().add(OutletTypeChanged(v));
        }
      },
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
