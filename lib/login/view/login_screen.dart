import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:outlet_expense/login/bloc/login_bloc.dart';
import 'package:outlet_expense/Signup/view/sign_up_screen.dart';
import '../../Custom-Component/Password.dart';
import '../../Custom-Component/Submit_Button.dart';
import '../../Custom-Component/TextField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;
  late final LoginBloc _loginBloc;
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc();
  }

  @override
  void dispose() {
    _loginBloc.close();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Times New Roman',
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (_) => _loginBloc,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BlocBuilder<LoginBloc, LoginState>(
                    buildWhen: (previous, current) =>
                        previous.email != current.email,
                    builder: (context, state) {
                      return CustomTextField(
                        label: "Email",
                        hint: "Email",
                        keyboardType: TextInputType.emailAddress,
                        focusNode: emailFocusNode,
                        prefixIcon: Icons.email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email cannot be empty";
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return "Enter a valid email";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          context.read<LoginBloc>().add(
                            EmailChanged(email: value),
                          );
                        },
                      );
                    },
                  ),
                  const Gap(16),
                  BlocBuilder<LoginBloc, LoginState>(
                    buildWhen: (previous, current) =>
                        previous.password != current.password,
                    builder: (context, state) {
                      return CustomPasswordField(
                        label: "Password",
                        hint: "Password",
                        focusNode: passwordFocusNode,
                        onChanged: (value) {
                          context.read<LoginBloc>().add(
                            PasswordChanged(password: value),
                          );
                        },
                      );
                    },
                  ),
                  const Gap(24),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: 'Login',
                        isLoading: state.loginStatus == LoginStatus.loading,
                        onPressed: () {
                          context.read<LoginBloc>().add(const LoginApi());
                        },
                      );
                    },
                  ),
                  const Gap(16),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Color.fromARGB(255, 35, 59, 201),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Gap(8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 35, 59, 201),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
