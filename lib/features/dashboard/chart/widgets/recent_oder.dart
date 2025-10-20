import 'package:flutter/material.dart';

// A good-looking Flutter component that displays a dynamic order value on the left
// and a circular, right-arrow button on the right, now using responsive dimensions.
class RecentOrderOneValue extends StatelessWidget {
  // Required argument for the order value
  final String orderValue;

  const RecentOrderOneValue({
    super.key,
    required this.orderValue,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive scaling
    final screenWidth = MediaQuery.of(context).size.width;

    // Define scaled dimensions (using screen width as the base for consistency)
    // These proportions ensure that the elements scale nicely across different devices.
    final horizontalPadding = screenWidth * 0.04; // 4% of screen width
    final verticalPadding = screenWidth * 0.03;  // 3% of screen width
    final horizontalMargin = screenWidth * 0.05; // 5% of screen width
    final buttonSize = screenWidth * 0.095;       // ~38 for a typical mobile screen
    final iconSize = screenWidth * 0.055;        // ~22 for a typical mobile screen
    final valueFontSize = screenWidth * 0.05;    // ~20 for a typical mobile screen

    // 1. Container: Provides the background, rounded corners, and a subtle shadow
    return Container(
      // Responsive padding
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      // Responsive margin
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          // Subtle, modern shadow for a lifted look
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4), // Fixed offset is usually fine for shadows
          ),
        ],
      ),
      child: Row(
        // 2. Row: Arranges the children horizontally, pushing them to the edges
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Left side: The dynamic value
          Text(
            orderValue, // Display the passed-in value
            style: TextStyle(
              fontSize: valueFontSize, // Responsive font size
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1E293B), // A dark, sophisticated text color
            ),
          ),

          // Right side: The circular button with the right arrow
          Container(
            // Responsive width and height for the circle button
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: const Color(0xFF06B6D4), // Vibrant teal/cyan color for visibility
              shape: BoxShape.circle,
              boxShadow: [
                // A slight shadow on the button itself
                BoxShadow(
                  color: const Color(0xFF06B6D4).withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              padding: EdgeInsets.zero, // Remove default padding for maximum icon size
              iconSize: iconSize, // Responsive icon size
              icon: const Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
              // Placeholder for the tap action
              onPressed: () {
                debugPrint('Navigating to recent orders for ID: $orderValue');
              },
            ),
          ),
        ],
      ),
    );
  }
}
