import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Widgets/common_app_bar.dart';
import '../../Widgets/next_button.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/signup_event.dart';
import '../bloc/signup_state.dart';

class SignupPage1 extends StatefulWidget {
  @override
  _SignupPage1State createState() => _SignupPage1State();
}

class _SignupPage1State extends State<SignupPage1> {
  final _userNameController = TextEditingController();
  final _outletNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final signupBloc = context.read<SignupBloc>();
    _userNameController.text = signupBloc.currentData.userName;
    _outletNameController.text = signupBloc.currentData.outletName;

    _userNameController.addListener(() {
      signupBloc.add(UpdateUserName(_userNameController.text));
    });

    _outletNameController.addListener(() {
      signupBloc.add(UpdateOutletName(_outletNameController.text));
    });
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _outletNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(showBackButton: false),
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
                    'Basic Information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please enter your basic information to get started',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _userNameController,
                    decoration: const InputDecoration(
                      labelText: 'User Name *',
                      hintText: 'Enter your user name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter user name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _outletNameController,
                    decoration: const InputDecoration(
                      labelText: 'Outlet Name *',
                      hintText: 'Enter your outlet name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.store),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter outlet name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: NextButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.pushNamed(context, '/signup/2');
          }
        },
      ),
    );
  }
}
