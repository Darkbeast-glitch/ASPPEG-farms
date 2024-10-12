import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/my_buttons.dart';
import 'package:myapp/utils/onboarding_card.dart';
import 'package:myapp/providers/onboarding_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  // Method to mark onboarding as completed
  Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasViewedOnboarding', true); // Save onboarding status
    Navigator.pushReplacementNamed(
        context, '/auth'); // Navigate to login/auth page
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize the PageController within the build method
    final currentPage = ref.watch(currentPageProvider);
    final controller = PageController(initialPage: currentPage);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background image with a darker overlay
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
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
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),

            // Welcome and Skip row
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
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "Skip",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Product Sans Regular',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // App title text
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "ASPPEG REPORT APP",
                  style: AppConstants.titleTextStyle.copyWith(
                    fontSize: 23,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // PageView for onboarding cards
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: screenWidth > 600 ? 600 : screenWidth * 0.8,
                ),
                child: SizedBox(
                  height: 300, // Set appropriate height for the cards
                  child: PageView(
                    controller: controller,
                    onPageChanged: (index) {
                      ref.read(currentPageProvider.notifier).state = index;
                    },
                    children: const [
                      OnboadingCards(
                        
                        imagePath: "assets/images/smartphone.png",
                        shortDescription:
                            "Crop Disease \nDetection \nin Single Click",
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
            ),

            // Page indicator for the PageView
            Align(
              alignment: const Alignment(0, 0.7),
              child: SmoothPageIndicator(
                controller: controller,
                count: pageCount, // Ensure this variable is properly defined
                effect: const WormEffect(),
                onDotClicked: (index) {
                  controller.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),

            // Buttons positioned at the bottom
            Positioned(
              bottom: 16,
              left: 32,
              right: 32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const MyButton(text: "Login"),
                  MyButton(
                    text: currentPage == pageCount - 1 ? "Get started" : "Next",
                    onTap: () {
                      if (currentPage < pageCount - 1) {
                        controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _completeOnboarding(context);
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
