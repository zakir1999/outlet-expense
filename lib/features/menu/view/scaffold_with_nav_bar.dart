import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/navigation_bloc.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import '../bloc/navigation_event.dart';
import '../bloc/navigation_state.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
            body: navigationShell,
            extendBody: true,
            bottomNavigationBar: AnimatedNotchBottomBar(
              notchBottomBarController: NotchBottomBarController(index: state.index),
              onTap: (index) {
                context.read<NavigationBloc>().add(NavigateTo(index));
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
              bottomBarItems: [
                BottomBarItem(
                  inActiveItem: const Icon(Icons.home, color: Colors.white),
                  activeItem: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueAccent,
                    ),
                    child: const Icon(Icons.home, color: Colors.white),
                  ),
                ),
                BottomBarItem(
                  inActiveItem: const Icon(Icons.pie_chart, color: Colors.white),
                  activeItem: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueAccent,
                    ),
                    child: const Icon(Icons.pie_chart_outline, color: Colors.white),
                  ),
                ),
                BottomBarItem(
                  inActiveItem: const Icon(Icons.shopping_cart, color: Colors.white),
                  activeItem: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueAccent,
                    ),
                    child: const Icon(Icons.shopping_cart, color: Colors.white),
                  ),
                ),
                BottomBarItem(
                  inActiveItem: const Icon(Icons.pages, color: Colors.white),
                  activeItem: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueAccent,
                    ),
                    child: const Icon(Icons.pages, color: Colors.white),
                  ),
                ),
              ],
              kIconSize: 25.0,
              kBottomRadius: 25.0,
              color: const Color.fromRGBO(35, 59, 201, 1.0), // opacity 1.0 = fully visible
            showLabel: false,
            ),
          );
      },
    );
  }
}
