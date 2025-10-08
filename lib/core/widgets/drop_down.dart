import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final String? hint;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String?>? onChanged;
  final String? errorText;
  final double borderRadius;
  final Color borderColor;
  final EdgeInsetsGeometry? padding;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.options,
    this.selectedValue,
    this.onChanged,
    this.hint,
    this.errorText,
    this.borderRadius = 12.0,
    this.borderColor = Colors.grey,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth < 360 ? 14.0 : 16.0;

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: errorText != null ? Colors.red : borderColor,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: hint != null
                    ? Text(hint!, style: TextStyle(fontSize: fontSize))
                    : null,
                value: selectedValue,
                icon: const Icon(Icons.keyboard_arrow_down),
                onChanged: onChanged,
                items: options
                    .map(
                      (option) => DropdownMenuItem<String>(
                        value: option,
                        child: Text(
                          option,
                          style: TextStyle(fontSize: fontSize),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text(
                errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
