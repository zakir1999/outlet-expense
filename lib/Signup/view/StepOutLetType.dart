// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../blocs/signup_bloc.dart';
// import '../blocs/signup_event.dart';
// import '../blocs/signup_state.dart';
// import '../widgets/common_app_bar.dart';
// import '../widgets/next_button.dart';

// class SignupPage2 extends StatefulWidget {
//   @override
//   _SignupPage2State createState() => _SignupPage2State();
// }

// class _SignupPage2State extends State<SignupPage2> {
//   String? selectedOutletType;
//   List<String> selectedModules = [];
  
//   final List<String> outletTypes = [
//     'Restaurant',
//     'Retail Store',
//     'Cafe',
//     'Bar',
//     'Fast Food',
//   ];

//   final List<String> moduleNames = [
//     'Inventory Management',
//     'Sales Analytics',
//     'Customer Management',
//     'Employee Management',
//     'Financial Reports',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     final signupBloc = context.read<SignupBloc>();
//     selectedOutletType = signupBloc.currentData.outletType.isEmpty 
//         ? null 
//         : signupBloc.currentData.outletType;
//     selectedModules = List.from(signupBloc.currentData.selectedModules);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CommonAppBar(),
//       body: BlocBuilder<SignupBloc, SignupState>(
//         builder: (context, state) {
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 30),
//                 const Text(
//                   'Business Setup',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   'Select your outlet type and modules you want to use',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 const Text(
//                   'Select Outlet Type *',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 DropdownButtonFormField<String>(
//                   value: selectedOutletType,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'Choose outlet type',
//                   ),
//                   items: outletTypes.map((String type) {
//                     return DropdownMenuItem<String>(
//                       value: type,
//                       child: Text(type),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       selectedOutletType = newValue;
//                     });
//                     if (newValue != null) {
//                       context.read<SignupBloc>().add(UpdateOutletType(newValue));
//                     }
//                   },
//                   validator: (value) {
//                     if (value == null) {
//                       return 'Please select outlet type';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 30),
//                 const Text(
//                   'Select Modules You Want to Use',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 ...moduleNames.map((module) {
//                   return CheckboxListTile(
//                     title: Text(module),
//                     value: selectedModules.contains(module),
//                     onChanged: (bool? value) {
//                       setState(() {
//                         if (value == true) {
//                           selectedModules.add(module);
//                         } else {
//                           selectedModules.remove(module);
//                         }
//                       });
//                       context.read<SignupBloc>().add(UpdateSelectedModules(List.from(selectedModules)));
//                     },
//                     controlAffinity: ListTileControlAffinity.leading,
//                   );
//                 }).toList(),
//                 const SizedBox(height: 60),
//               ],
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: NextButton(
//         onPressed: () {
//           if (selectedOutletType != null) {
//             Navigator.pushNamed(context, '/signup/3');
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Please select outlet type')),
//             );
//           }
//         },
//       ),
//     );
//   }
// }