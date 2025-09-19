import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Widgets/common_app_bar.dart';
import '../../Widgets/next_button.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/signup_event.dart';
import '../bloc/signup_state.dart';

class SignupPage5 extends StatefulWidget {
  @override
  _SignupPage5State createState() => _SignupPage5State();
}

class _SignupPage5State extends State<SignupPage5> {
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final signupBloc = context.read<SignupBloc>();
    _pinController.text = signupBloc.currentData.pin;

    _pinController.addListener(() {
      signupBloc.add(UpdatePin(_pinController.text));
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
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
                    'Create PIN',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create a 4-digit PIN for quick access to your account',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Container(
                      width: 200,
                      child: TextFormField(
                        controller: _pinController,
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
                          labelText: 'PIN',
                          hintText: '••••',
                          border: OutlineInputBorder(),
                          counterText: '',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter PIN';
                          }
                          if (value.length != 4) {
                            return 'PIN must be 4 digits';
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
      bottomNavigationBar: NextButton(
        text: 'Continue',
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.pushNamed(context, '/signup/6');
          }
        },
      ),
    );
  }
}
