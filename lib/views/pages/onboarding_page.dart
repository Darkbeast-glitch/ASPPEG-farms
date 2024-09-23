import 'package:flutter/material.dart';
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
                Colors.black.withOpacity(0.1), // Darken the image
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
                        color: Colors.black,
                        fontFamily: 'Product Sans Regular',
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "Skip",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Product Sans Regular',
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            // A text with the name ASPPEG REPORT APP goes here

            // a container goes inthe middle with and Image of a Phone  and some text

            Container(
              alignment: const Alignment(0, 0),
              child: SmoothPageIndicator(
                  controller: _controller, // PageController
                  count: 3,
                  effect: const WormEffect(), // your preferred effect
                  onDotClicked: (index) {}),
            )

            // in the container after the image we have a text with Crop Disease in Single Click

            //  a button for login and a button for next
            // Foreground content
          ],
        ),
      ),
    );
  }
}
