import 'package:flutter/material.dart';

class OverviewCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const OverviewCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF232121),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 20),
        title: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        trailing: Text(
          value,
          style: const TextStyle(
              fontFamily: "Product Sans Bold",
              fontSize: 14,
              color: Colors.white),
        ),
      ),
    );
  }
}
