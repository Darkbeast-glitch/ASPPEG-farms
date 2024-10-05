import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MediumButtons extends StatelessWidget {
  final Icon icon;
  final String text;
  final Color color;
  final void Function()? onTap;

  const MediumButtons({
    super.key,
    required this.text,
    this.onTap,
    required this.icon, required this.color,
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
          color:color
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.3),
          //     spreadRadius: 1,
          //     blurRadius: 3,
          //     offset: const Offset(0, 3), // changes position of shadow
          //   ),
          // ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const Gap(10),
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
