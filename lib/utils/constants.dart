import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const Color primaryColor = Colors.green;
  static const Color secondaryColor = Color.fromARGB(255, 27, 63, 161);
  static const Color backgroundColor = Color.fromARGB(255, 33, 29, 29);
  static const Color textColor = Colors.black;

  // Fonts
  static const String primaryFontFamily = 'Product Sans Bold';
  static const String secondaryFontFamily = 'Product Sans Regular';
  // static const String secondaryFontFamily = 'Arial';

  // API KEY

  // Text Styles
  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textColor,
    fontFamily: primaryFontFamily,
  );

  static const TextStyle seconTitleTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w100,
    color: textColor,
    fontFamily: primaryFontFamily,
  );
  static const TextStyle subtitleTextStyle = TextStyle(
    fontSize: 15,
    color: textColor,
    fontFamily: secondaryFontFamily,
  );

  static const TextStyle hintTextStyle = TextStyle(
    fontSize: 15,
    color: textColor,
    fontFamily: secondaryFontFamily,
  );
  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    color: textColor,
    fontFamily: primaryFontFamily,
  );

  // Button Styles
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: textColor,
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    textStyle: buttonTextStyle,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
  static ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: secondaryColor,
    foregroundColor: textColor,
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    textStyle: buttonTextStyle,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  // DimensionsA
  static const double imageHeight = 200;
  static const double buttonHorizontalPadding = 30.0;
  static const double buttonVerticalPadding = 15.0;
  static const double progressIndicatorDotSize = 10.0;

  // Other
  static const String skipButtonText = "Skip";
  static const String nextButtonText = "Next";
  static const String finishButtonText = "Finish";
}
