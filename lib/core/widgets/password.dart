import 'package:flutter/material.dart';
import 'TextField.dart';

class CustomPasswordField extends StatefulWidget {
  final String label;
  final String hint;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const CustomPasswordField({
    super.key,
    required this.label,
    required this.hint,
    this.focusNode,
    this.controller,
    this.onChanged,
    this.validator,
  });

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: widget.label,
      hint: widget.hint,
      keyboardType: TextInputType.visiblePassword,
      obscureText: !isPasswordVisible,
      focusNode: widget.focusNode,
      controller: widget.controller,

      suffixIcon: isPasswordVisible ? Icons.visibility : Icons.visibility_off,
      onSuffixTap: () {
        setState(() {
          isPasswordVisible = !isPasswordVisible;
        });
      },
      validator:
          widget.validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return "Password cannot be empty";
            }
            if (value.length < 6) {
              return "Password must be at least 6 characters";
            }
            return null;
          },
      onChanged: widget.onChanged,
    );
  }
}
