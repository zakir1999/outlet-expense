import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/password.dart';
import '../../../core/widgets/TextField.dart';

import '../../Signup/view/sign_up_page1.dart';

import '../bloc/login_bloc.dart';

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
    final horizontalPadding = screenWidth * 0.08;
    final titleFontSize = screenWidth < 400 ? 18.0 : 22.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Times New Roman',
            fontSize: titleFontSize,
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
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: SizedBox(
                height: constraints.maxHeight,
                child: BlocListener<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state.loginStatus == LoginStatus.success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message.isNotEmpty
                              ? state.message
                              : 'Login Successful!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                        context.go('/');
                    }

                    else if (state.loginStatus == LoginStatus.error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message.isNotEmpty
                              ? state.message
                              : 'Something went wrong, please try again'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }

                    if (state.navigateToSignUp) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignupPage1()),
                      );
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top flexible space
                      Expanded(flex: 2, child: SizedBox()),

                      // Email Field
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
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              context
                                  .read<LoginBloc>()
                                  .add(EmailChanged(email: value));
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // Password Field
                      BlocBuilder<LoginBloc, LoginState>(
                        buildWhen: (previous, current) =>
                        previous.password != current.password,
                        builder: (context, state) {
                          return CustomPasswordField(
                            label: "Password",
                            hint: "Password",
                            focusNode: passwordFocusNode,
                            onChanged: (value) {
                              context
                                  .read<LoginBloc>()
                                  .add(PasswordChanged(password: value));
                            },
                          );
                        },
                      ),

                      // Flexible space between fields and button
                      Expanded(flex: 1, child: SizedBox()),

                      // Login Button
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              text: 'Login',
                              isLoading:
                              state.loginStatus == LoginStatus.loading,
                              onPressed: () {
                                context.read<LoginBloc>().add(const LoginApi());
                              },
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      // Forgot Password
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

                      const SizedBox(height: 16),

                      // Sign Up Text
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
                                  builder: (context) => const SignupPage1(),
                                ),
                              );
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 35, 59, 201),
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                Color.fromARGB(255, 35, 59, 201),
                                decorationThickness: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Bottom flexible space
                      Expanded(flex: 2, child: SizedBox()),
                    ],
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
