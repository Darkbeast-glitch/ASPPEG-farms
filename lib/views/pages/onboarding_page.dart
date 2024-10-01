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
  final int pageCount = 4; // Number of intro cards
  int currentPage = 0; // Track current page

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        currentPage = _controller.page!.round();
      });
    });
  }

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

            // PageView for only the cards with a controlled width
            Center(
              child: SizedBox(
                height: 300, // Set appropriate height for the cards
                width: MediaQuery.of(context).size.width *
                    0.65, // Set width to 65% of the screen width
                child: PageView(
                  controller: _controller,
                  children: const [
                    OnboadingCards(
                      imagePath: "assets/images/smartphone.png",
                      shortDescription:
                          "Crop Disease \nDetection \nin Single Click ",
                    ),
                    OnboadingCards(
                      imagePath: "assets/images/report.png",
                      shortDescription: "Detailed \nAnalysis \nFor Experts",
                    ),
                    OnboadingCards(
                      imagePath: "assets/images/Insect.png",
                      shortDescription: "Monitor your\nPest",
                    ),
                    OnboadingCards(
                      imagePath: "assets/images/calculator.png",
                      shortDescription: "Generate \nReports \nEffortlessly",
                    ),
                  ],
                ),
              ),
            ),

            // Page indicator for the PageView
            Container(
              alignment: const Alignment(0, 0.7),
              child: SmoothPageIndicator(
                controller: _controller, // PageController
                count: pageCount, // Number of pages (4)
                effect: const WormEffect(), // Smooth indicator effect
                onDotClicked: (index) {
                  _controller.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),

            // Buttons positioned at the bottom
            Positioned(
              bottom: 8,
              left: 40,
              right: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const MyButton(text: "Login"),

                  // Updated Next/Get Started Button Logic
                  MyButton(
                    text: currentPage == pageCount - 1 ? "Get started" : "Next",
                    onTap: () {
                      if (currentPage < pageCount - 1) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        // Handle the 'Get started' action here
                        // Example: Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
