import 'package:flutter/material.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/my_buttons.dart';
import 'package:myapp/utils/onboarding_card.dart';
import 'dart:ui';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background image with a darker overlay
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), // Darken the image
                BlendMode.darken,
              ),
              child: Image.asset(
                'assets/images/backImage.jpg',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            // Blur effect
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3), // Subtle blur
              child: Container(
                color: Colors.black.withOpacity(0), // Transparent overlay
              ),
            ),
            // a row of two text called Welcome and Skip
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Welcome",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Product Sans Regular',
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "Skip",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Product Sans Regular',
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            // A text with the name ASPPEG REPORT APP goes here
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ASPPEG REPORT APP",
                    style: AppConstants.titleTextStyle
                        .copyWith(fontSize: 23, color: Colors.white),
                  ),
                ],
              ),
            ),

            const Center(
              child: OnboadingCards(
                imagePath: "assets/images/smartphone.png",
                shortDescription: "Crop Disease \nDetection \nin Snigle Click ",
              ),
            ),

            // a container goes inthe middle with and Image of a Phone  and some text

            Container(
              alignment: const Alignment(0, 0.6),
              child: SmoothPageIndicator(
                  controller: _controller, // PageController
                  count: 3,
                  effect: const WormEffect(), // your preferred effect
                  onDotClicked: (index) {}),
            ),
            const Positioned(
              bottom: 8,
              left: 30,
              right: 30,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Use spaceBetween
                children: [
                  MyButton(text: "Login"),
                  MyButton(text: "Next"),
                ],
              ),
            )

            //  a button for login and a button for next
            // Foreground content
          ],
        ),
      ),
    );
  }
}
