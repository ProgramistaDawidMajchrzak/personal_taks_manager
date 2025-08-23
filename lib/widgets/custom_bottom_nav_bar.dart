import 'package:flutter/material.dart';
import '../views/home_view.dart';
import '../views/stats_view.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF4A3780),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.list), label: "Tasks"),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Stats"),
      ],
      onTap: (index) {
        if (index == currentIndex) return;

        Widget targetScreen;
        switch (index) {
          case 0:
            targetScreen = const HomeView();
            break;
          case 1:
            targetScreen = const StatsView();
            break;
          default:
            return;
        }

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => targetScreen,
            transitionsBuilder: (_, animation, __, child) {
              // Fade + Slide
              final offsetAnim = Tween<Offset>(
                begin: const Offset(0.0, 0.1), // lekko w dół
                end: Offset.zero,
              ).animate(animation);

              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: offsetAnim, child: child),
              );
            },
          ),
        );
      },
    );
  }
}
