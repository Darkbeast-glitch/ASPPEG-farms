import 'package:flutter/material.dart';
import 'package:myapp/utils/constants.dart';

class ArrivalTextForm extends StatelessWidget {
  const ArrivalTextForm(
      {super.key,
      required this.labelText,
      required this.hintText,
      required this.controller,
      required this.suffixicon,  this.type});
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final Icon? suffixicon;
  final TextInputType? type;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[800],
        labelStyle: AppConstants.subtitleTextStyle
            .copyWith(color: Colors.white, fontSize: 14),
        hintStyle: const TextStyle(color: Colors.white70),
        suffixIcon: suffixicon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      keyboardType: type,
    );
  }
}
