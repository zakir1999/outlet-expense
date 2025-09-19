import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Widgets/common_app_bar.dart';
import '../../Widgets/next_button.dart';
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
      body: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Signup successful!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
            );
          } else if (state is SignupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<SignupBloc, SignupState>(
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
                      'Confirm PIN',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please confirm your 4-digit PIN',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: Container(
                        width: 200,
                        child: TextFormField(
                          controller: _confirmPinController,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          textAlign: TextAlign.center,
                          maxLength: 4,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 8,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Confirm PIN',
                            hintText: '••••',
                            border: OutlineInputBorder(),
                            counterText: '',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm PIN';
                            }
                            if (value.length != 4) {
                              return 'PIN must be 4 digits';
                            }
                            final signupBloc = context.read<SignupBloc>();
                            if (value != signupBloc.currentData.pin) {
                              return 'PINs do not match';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<SignupBloc, SignupState>(
        builder: (context, state) {
          return NextButton(
            text: 'Continue',
            isLoading: state is SignupSubmitting,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<SignupBloc>().add(const SubmitSignup());
              }
            },
          );
        },
      ),
    );
  }
}
