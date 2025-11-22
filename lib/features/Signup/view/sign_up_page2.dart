import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/drop_down.dart';
import '../bloc/signup_event.dart';

import '../../../core/widgets/common_app_bar.dart';
import '../../../core/widgets/next_button.dart';

import '../bloc/signup_bloc.dart';
import '../bloc/signup_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupPage2 extends StatefulWidget {
  @override
  _SignupPage2State createState() => _SignupPage2State();
}

class _SignupPage2State extends State<SignupPage2> {
  String? selectedOutletType;
  List<String> selectedModules = [];

  final List<String> outletTypes = ['Pharmacy', 'POS'];

  final List<Map<String, String>> moduleData = [
    {"name": "Expense", "description": "Module feature"},
    {"name": "POS", "description": "Module feature"},
    {"name": "HRM", "description": "Module feature"},
    {"name": "Payroll", "description": "Module feature"},
    {"name": "Attendance", "description": "Module feature"},
  ];

  @override
  void initState() {
    super.initState();
    final signupBloc = context.read<SignupBloc>();
    selectedOutletType = signupBloc.currentData.outletType.isEmpty
        ? null
        : signupBloc.currentData.outletType;
    selectedModules = List.from(signupBloc.currentData.selectedModules);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: BlocBuilder<SignupBloc, SignupState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Provide us your Store \nType & select module',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'for create a store for you, and keep trace your expense for you.',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color.fromARGB(255, 97, 96, 96),
                  ),
                ),
                SizedBox(height: 10.h),
                CustomDropdown(
                  hint: 'Select outlet type',
                  label: '',
                  options: ['Pharmacy', 'POS'],
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOutletType = newValue;
                    });
                    if (newValue != null) {
                      context.read<SignupBloc>().add(
                        UpdateOutletType(newValue),
                      );
                    }
                  },
                ),
                SizedBox(height: 20.h),
                const Text(
                  'Select module you want to Use',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10.h),

                ...moduleData.map((module) {
                  final isSelected = selectedModules.contains(module["name"]);
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.lock_outline,
                                size: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      module["name"]!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      module["description"]!,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Switch(
                          value: isSelected,
                          onChanged: (bool value) {
                            setState(() {
                              if (value) {
                                selectedModules.add(module["name"]!);
                              } else {
                                selectedModules.remove(module["name"]!);
                              }
                            });
                            context.read<SignupBloc>().add(
                              UpdateSelectedModules(List.from(selectedModules)),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }),
                SizedBox(height: 10.h),
                NextButton(
                  onPressed: () {
                    if (selectedOutletType != null) {
                      context.push( '/signup/3');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select outlet type'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
