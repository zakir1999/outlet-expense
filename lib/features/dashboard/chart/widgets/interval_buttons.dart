import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chart_bloc.dart'; // Assuming this import is correct

class IntervalButtons extends StatefulWidget {
  const IntervalButtons({super.key});

  @override
  State<IntervalButtons> createState() => _IntervalButtonsState();
}

class _IntervalButtonsState extends State<IntervalButtons> {
  String selected = 'daily';

  @override
  Widget build(BuildContext context) {
    final intervals = ['Daily', 'Weekly', 'Monthly', 'Yearly'];

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4), // Reduced padding for a more compact look
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // Using `Expanded` ensures each button takes equal width.
          children: intervals.map((interval) {
            final lower = interval.toLowerCase();
            return Expanded(
              // **Removed the redundant inner Container here.**
              child: _HoverButton(
                label: interval,
                isSelected: selected == lower,
                onTap: () {
                  setState(() => selected = lower);
                  // The `context.read` call will require your BLoC setup to be correct.
                  // This is kept as per your original code.
                  context.read<ChartBloc>().add(FetchChartData(lower));
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _HoverButton extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _HoverButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isSelected || _isHovered;
    final Color darkBlue = Color(0xFF000080);
    final bgColor = isActive
        ? darkBlue
        : Colors.transparent;
    final textColor = isActive ? Colors.white : Colors.black87;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        // **To make the button take full height/width, we use a Container with `double.infinity`**
        // Since it's wrapped in an `Expanded`, it takes the available space.
        child: Container(
          // **Set both height and width to double.infinity**
          // This will make it fill the space given by `Expanded` and the `Row`'s height.
          // The height will be determined by the content padding.
          constraints: const BoxConstraints(minHeight: 45), // Ensure a minimum height if needed
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            // Adjust padding to control the final height
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(25), // Reduced slightly to fit better inside the 25-radius parent
              boxShadow: isActive
                  ? [
                BoxShadow(
                  color: Colors.blue[800]?.withOpacity(0.3) ?? Colors.blue.withOpacity(0.3),                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ]
                  : null, // Removed shadow for unselected state for a cleaner look
              // **REMOVED border definition**
            ),
            child: Center(
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// **Note on `ChartBloc`:**
// The line `context.read<ChartBloc>().add(FetchChartData(lower))` assumes you have a ChartBloc
// and a FetchChartData event defined and correctly provided higher up in your widget tree.