import 'package:flutter/material.dart';

class UpcomingActionCard extends StatelessWidget {
  final String actionTitle;
  final String dueDate;
  final int daysLeft;

  const UpcomingActionCard({
    super.key,
    required this.actionTitle,
    required this.dueDate,
    required this.daysLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black87,
      child: ListTile(
        title: Text(
          actionTitle,
          style: const TextStyle(
              color: Colors.white, fontFamily: "Product Sans Regular"),
        ),
        subtitle: Text(
          'Due: $dueDate\nCutting due in $daysLeft days',
          style: const TextStyle(
              color: Colors.grey, fontFamily: "Product Sans Regular"),
        ),
      ),
    );
  }
}
