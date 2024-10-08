import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MediumButtons extends StatelessWidget {
  final Icon? icon; // Make icon nullable
  final String text;
  final Color color;
  final void Function()? onTap;

  const MediumButtons({
    super.key,
    required this.text,
    this.onTap,
    this.icon, // Icon is now optional
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: color,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) icon!, // Only show the icon if it's provided
              if (icon != null) const Gap(10), // Add gap if icon is present
              Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontFamily: "Product Sans Bold",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
