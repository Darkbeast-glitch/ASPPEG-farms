import 'package:flutter/material.dart';

class MyTextForm extends StatelessWidget {
  const MyTextForm({
    super.key,
    required this.hintText,
    required this.prefix,
    required this.controller,
    this.validator,
    required this.obsecureText,
    this.errorText,
    this.onTap, // Optional onTap callback
    this.readOnly = false, // Option to make the field read-only
  });

  final String hintText;
  final Icon prefix;
  final String? errorText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obsecureText;
  final VoidCallback? onTap; // Optional onTap callback
  final bool readOnly; // Added read-only flag

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obsecureText,
      style: const TextStyle(color: Colors.black),
      readOnly: readOnly, // Apply read-only status if needed
      decoration: InputDecoration(
        prefixIcon: prefix,
        prefixIconColor: Colors.black54,
        errorText: errorText,
        errorStyle: const TextStyle(color: Colors.black),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: "Product Sans Regular",
          fontSize: 13
        ),
        filled: true,
        fillColor: Colors.grey[300], // Adjusted fill color for dimmer appearance
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10, // Reduced vertical padding to decrease height
          horizontal: 15, // Keep horizontal padding for comfort
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none, // No border by default
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Colors.blue, // Set the border color when focused
            width: 2, // Thickness of the focused border
          ),
        ),
      ),
      validator: validator,
      onTap: onTap, // Add onTap callback
    );
  }
}
