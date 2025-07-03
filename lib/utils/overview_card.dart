import 'package:flutter/material.dart';

class OverviewCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final void Function()? onTap;


  const OverviewCard({
    super.key,
    required this.icon,
    required this.label,
    this.value = '', 
    this.iconColor = Colors.green, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF232121),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 20),
        title: GestureDetector(
          onTap: onTap ,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ),
        trailing: Text(
          value,
          style: const TextStyle(
              fontFamily: "Product Sans Bold",
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
    );
  }
}
