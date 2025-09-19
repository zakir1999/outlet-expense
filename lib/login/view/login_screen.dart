import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../Widgets/custom_button.dart';
import '../bloc/login_bloc.dart';
import '../../Signup/view/sign_up_screen.dart';
import '../../Widgets/password.dart';
import '../../Widgets/textField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final horizontalPadding = screenWidth < 600 ? 16.0 : 32.0;
    final verticalPadding = screenWidth < 600 ? 16.0 : 24.0;

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
        elevation: 0,
      ),
      body: BlocProvider(
        create: (_) => _loginBloc,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                top: screenHeight * 0.10,
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
                        maxWidth: screenWidth < 600 ? double.infinity : 500,
                      ),
                      child: BlocListener<LoginBloc, LoginState>(
                        listener: (context, state) {
                          if (state.navigateToSignUp) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                    if (!RegExp(
                                      r'^[^@]+@[^@]+\.[^@]+',
                                    ).hasMatch(value)) {
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
                                  isLoading:
                                      state.loginStatus == LoginStatus.loading,
                                  onPressed: () {
                                    context.read<LoginBloc>().add(
                                      const LoginApi(),
                                    );
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
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 35, 59, 201),
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Color.fromARGB(
                                        255,
                                        35,
                                        59,
                                        201,
                                      ),
                                      decorationThickness: 1.5,
                                      height:
                                          1.5, // increase line height to push underline slightly down
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                          ],
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
