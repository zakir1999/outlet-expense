import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Signup/bloc/sign_up_bloc.dart';
import 'package:gap/gap.dart';
import './LockRadioList.dart';

class StepOutletType extends StatelessWidget {
  const StepOutletType({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth < 360 ? 14.0 : 16.0;

    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Provide us your Store \nType & select module',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              Gap(10),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'For create a store for you, and keep track your expense for you.',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 97, 96, 96),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Gap(10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text(
                      "Select Outlet Type",
                      style: TextStyle(fontSize: fontSize),
                    ),
                    value: state.outletType.isEmpty ? null : state.outletType,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    dropdownColor: Colors.white,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<SignUpBloc>().add(
                          OutletTypeChanged(value),
                        );
                      }
                    },
                    items: const [
                      DropdownMenuItem(value: "Shop", child: Text("Shop")),
                      DropdownMenuItem(
                        value: "Restaurant",
                        child: Text("Restaurant"),
                      ),
                      DropdownMenuItem(value: "Other", child: Text("Other")),
                    ],
                  ),
                ),
              ),

              Gap(10),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select the module you want to use',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 97, 96, 96),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Gap(10),
              Container(
                alignment: Alignment.centerLeft,
                child: const LockSwitchList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class LockSwitchList extends StatefulWidget {
  const LockSwitchList({super.key});

  @override
  State<LockSwitchList> createState() => _LockSwitchListState();
}

class _LockSwitchListState extends State<LockSwitchList> {
  final List<Map<String, dynamic>> items = [
    {"title": "Expense", "description": "Module feature", "enabled": false},
    {"title": "POS", "description": "Module feature", "enabled": false},
    {"title": "HRM", "description": "Module feature", "enabled": false},
    {"title": "Payroll", "description": "Module feature", "enabled": false},
    {"title": "Attendence", "description": "Module feature", "enabled": false},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth < 360 ? 14.0 : 16.0;
    final descFontSize = screenWidth < 360 ? 12.0 : 14.0;

    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            color: Colors.white,
          ),
          child: Row(
            children: [
              const Icon(Icons.lock, color: Colors.grey),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["title"],
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item["description"],
                      style: TextStyle(
                        fontSize: descFontSize,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: item["enabled"],
                onChanged: (value) {
                  setState(() {
                    items[index]["enabled"] = value;
                  });
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
