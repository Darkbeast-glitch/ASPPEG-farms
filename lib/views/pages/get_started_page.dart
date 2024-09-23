import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/my_buttons.dart'; // Needed for the BackdropFilter widget

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
          // Foreground content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Image.asset(
                      'assets/images/Logo.png', // Example logo image
                      width: 200,
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ASPPEG REPORT APP',
                    style: AppConstants.titleTextStyle.copyWith(
                      fontSize: 23, // Example font size
                      color: Colors.white, // Example color
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Smart Reporting for Better\nSweet Potato Yield',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Product Sans Regular",
                      color: Colors.white,
                    ),
                  ),
                  // my button
                  const SizedBox(
                    height: 10,
                  ),
                  MyButton(
                    text: "Get Started",
                    onTap: () {
                      Navigator.pushNamed(context, '/home');
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
