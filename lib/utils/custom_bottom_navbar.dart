import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 33, 29, 29),
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.5), // Top border styling
        ),
      ),
      child: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.batch_prediction),
            label: 'Batches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.transparent, // Transparent to see the container color
        elevation: 0, // Removes the shadow from the bottom navigation bar
        onTap: onTap,
      ),
    );
  }
}
