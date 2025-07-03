import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:myapp/utils/constants.dart';

class OnboadingCards extends StatelessWidget {
  const OnboadingCards({
    super.key,
    required this.shortDescription,
    required this.imagePath,
  });
  final String shortDescription;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 224,
        height: 296,
        decoration: BoxDecoration(
          // this will take a background color with hex code 5DD003,  and border color and also border radius
          color: const Color(0xFF5DD003).withOpacity(0.78),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFFFFF), width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            children: [
              // The image of the card
              // Show the image as-is (no transform)
              Image.asset(imagePath),
              const Gap(20),

              // a short descirption
              Text(
                textAlign: TextAlign.center,
                shortDescription,
                style: AppConstants.subtitleTextStyle.copyWith(fontSize: 17),
              )
            ],
          ),
        )
        //,
        );
  }
}
