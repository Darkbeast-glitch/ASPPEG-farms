import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'dart:ui';

import 'package:myapp/services/auth_services.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/my_textfield.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key, this.onTap});
  final Function()? onTap;

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  Future<void> _registerUser() async {
    final String name = _fullnameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    // Dismiss the keyboard
    FocusScope.of(context).unfocus();

    // Check if passwords match
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Passwords do not match!'),
        ),
      );
      return;
    }

    // Show loading indicator
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      // Access the auth service and attempt to register the user
      final authService = ref.read(authServiceProvider);
      await authService.signUpWithEmailAndPassword(
          name, email, password, context);
    } catch (e) {
      // Handle any errors that weren't caught in signUpWithEmailAndPassword
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(e.toString()),
          ),
        );
      }
    } finally {
      // Hide loading indicator only if the widget is still mounted
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          // Background image with a darker overlay
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.7),
              BlendMode.darken,
            ),
            child: Image.asset(
              'assets/images/farm.jpg',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          // Blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              color: Colors.black.withOpacity(0),
            ),
          ),
          Center(
            // Use Center widget to ensure all content stays centered
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth > 600 ? 600 : screenWidth * 0.9,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30), // Gap at the top
                      Text(
                        "Create an account",
                        style: AppConstants.titleTextStyle
                            .copyWith(color: Colors.white, fontSize: 30),
                      ),
                      const Text(
                        "Let's get you an account \ncreate your account.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Product Sans Regular",
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w300),
                      ),
                      const Gap(50),
                      MyTextForm(
                        hintText: "Fullname",
                        prefix: const Icon(Icons.person),
                        controller: _fullnameController,
                        obsecureText: false,
                      ),
                      const Gap(10),
                      MyTextForm(
                        hintText: "Email",
                        prefix: const Icon(Icons.email),
                        controller: _emailController,
                        obsecureText: false,
                      ),
                      const Gap(10),
                      MyTextForm(
                        hintText: "Password",
                        prefix: const Icon(Icons.lock),
                        controller: _passwordController,
                        obsecureText: true,
                      ),
                      const Gap(10),
                      MyTextForm(
                        hintText: "Confirm Password",
                        prefix: const Icon(Icons.lock),
                        controller: _confirmPasswordController,
                        obsecureText: true,
                      ),
                      const Gap(30),
                      GestureDetector(
                        onTap: () async {
                          if (_passwordController.text !=
                              _confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Passwords do not match!'),
                              ),
                            );
                            return;
                          }

                          try {
                            await _registerUser();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${e.toString()}')),
                            );
                          }
                        },
                        child: Container(
                          height: 47,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.green,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Center(
                                  child: Text(
                                    "Create account",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontFamily: "Product Sans Regular",
                                    ),
                                  ),
                                ),
                        ),
                      ),

                      const Gap(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: AppConstants.subtitleTextStyle
                                .copyWith(color: Colors.white, fontSize: 13),
                          ),
                          const Gap(5),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: Text(
                              "Login.",
                              style: AppConstants.subtitleTextStyle
                                  .copyWith(color: Colors.blue, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const Gap(30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "Or Sign In with",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
