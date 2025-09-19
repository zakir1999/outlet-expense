import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/signup_bloc.dart';
import '../bloc/signup_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<SignupBloc, SignupState>(
        builder: (context, state) {
          final signupBloc = context.read<SignupBloc>();
          final userData = signupBloc.currentData;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to Your Dashboard!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Information:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildInfoRow('User Name:', userData.userName),
                        _buildInfoRow('Outlet Name:', userData.outletName),
                        _buildInfoRow('Outlet Type:', userData.outletType),
                        _buildInfoRow('Email:', userData.email),
                        _buildInfoRow('Phone:', userData.phoneNumber),
                        if (userData.selectedModules.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          const Text(
                            'Selected Modules:',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          ...userData.selectedModules.map(
                            (module) => Padding(
                              padding: const EdgeInsets.only(left: 16, top: 4),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(module),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your signup data has been successfully submitted to our API!',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
