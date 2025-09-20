



// class _SignUpView extends StatelessWidget {
//   const _SignUpView();

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final horizontalPadding = screenWidth < 600 ? 16.0 : 32.0;
//     final verticalPadding = screenWidth < 600 ? 16.0 : 24.0;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           "Sign Up",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontFamily: 'Times New Roman',
//             fontSize: 20,
//             color: Colors.black,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         elevation: 0,
//       ),
//       body: BlocProvider(
//         create: (_) => SignUpBloc(),
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return SingleChildScrollView(
//               padding: EdgeInsets.only(
//                 top: screenHeight * 0.05,
//                 left: horizontalPadding,
//                 right: horizontalPadding,
//                 bottom: verticalPadding,
//               ),
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   minHeight: constraints.maxHeight - verticalPadding * 2,
//                 ),
//                 child: IntrinsicHeight(
//                   child: Center(
//                     child: Container(
//                       constraints: BoxConstraints(
//                         maxWidth: screenWidth < 600 ? double.infinity : 600,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(24.0),
//                         child: BlocListener<SignUpBloc, SignUpState>(
//                           listener: (context, state) {
//                             if (state.status == SignUpStatus.success) {
//                               Navigator.pushReplacementNamed(context, "/home");
//                             }
//                             if (state.status == SignUpStatus.failure) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text("Registration failed"),
//                                 ),
//                               );
//                             }
//                           },
//                           child: BlocBuilder<SignUpBloc, SignUpState>(
//                             builder: (context, state) {
//                               return Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Expanded(
//                                     child: SingleChildScrollView(
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           const Gap(20),
//                                           if (state.step == 1)
//                                             StepUserOutletWrapper(),
//                                           if (state.step == 2) StepOutletType(),
//                                           if (state.step == 3)
//                                             _StepEmailPhone(),
//                                           if (state.step == 4) StepPasswordWrapper(),
//                                           if (state.step == 5) _StepPin(),
//                                           if (state.step == 6)
//                                             _StepConfirmPin(),
//                                           const Gap(30),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class _StepEmailPhone extends StatelessWidget {
//   final emailFocusNode = FocusNode();
//   final phoneFocusNode = FocusNode();
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         BlocBuilder<SignUpBloc, SignUpState>(
//           buildWhen: (previous, current) => previous.email != current.email,
//           builder: (context, state) {
//             return CustomTextField(
//               label: "Email",
//               hint: "Enter your E-mail",
//               keyboardType: TextInputType.emailAddress,
//               focusNode: emailFocusNode,
//               prefixIcon: Icons.email_outlined,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return "Email cannot be empty";
//                 }
//                 if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                   return "Enter a valid email";
//                 }
//                 return null;
//               },
//               onChanged: (value) {
//                 context.read<SignUpBloc>().add(EmailChanged(value));
//               },
//             );
//           },
//         ),
//         const Gap(16),
//         BlocBuilder<SignUpBloc, SignUpState>(
//           buildWhen: (previous, current) => previous.email != current.email,
//           builder: (context, state) {
//             return CustomTextField(
//               label: "Phone",
//               hint: "Enter your phone number",
//               keyboardType: TextInputType.phone,
//               focusNode: phoneFocusNode,
//               prefixIcon: Icons.phone_outlined,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return "Phone cannot be empty";
//                 } else {
//                   return null;
//                 }
//               },
//               onChanged: (value) {
//                 context.read<SignUpBloc>().add(PhoneChanged(value));
//               },
//             );
//           },
//         ),
//       ],
//     );
//   }
// }



// class _StepPin extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       obscureText: true,
//       maxLength: 6,
//       keyboardType: TextInputType.number,
//       decoration: const InputDecoration(labelText: "6 Digit Pin"),
//       onChanged: (v) => context.read<SignUpBloc>().add(PinChanged(v)),
//     );
//   }
// }

// class _StepConfirmPin extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       obscureText: true,
//       maxLength: 6,
//       keyboardType: TextInputType.number,
//       decoration: const InputDecoration(labelText: "Confirm 6 Digit Pin"),
//       onChanged: (v) => context.read<SignUpBloc>().add(ConfirmPinChanged(v)),
//     );
//   }
// }
