import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.focusNode,
    this.onChanged,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive font and padding for mobile and tablet
    double fontSize = 16;
    double horizontalPadding = 20;
    double verticalPadding = 18;

    if (screenWidth >= 360 && screenWidth < 600) {
      // Small mobile devices
      fontSize = 14;
      horizontalPadding = 16;
      verticalPadding = 14;
    } else if (screenWidth >= 600 && screenWidth < 1024) {
      // Tablet
      fontSize = 16;
      horizontalPadding = 20;
      verticalPadding = 18;
    } else if (screenWidth >= 1024) {
      // Desktop or larger (keep fixed)
      fontSize = 16;
      horizontalPadding = 20;
      verticalPadding = 18;
    }

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null
            ? GestureDetector(onTap: onSuffixTap, child: Icon(suffixIcon))
            : null,
        contentPadding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 225, 229, 233),
            width: 2,
          ),
        ),
      ),
    );
  }
}
