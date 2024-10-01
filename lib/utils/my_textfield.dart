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
  });

  final String hintText;
  final Icon prefix;
  final String? errorText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obsecureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obsecureText,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        prefixIcon: prefix,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: "Product Sans Regular",
        ),
        filled: true,
        fillColor: Colors.grey[300],
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
      validator: validator,
    );
  }
}
