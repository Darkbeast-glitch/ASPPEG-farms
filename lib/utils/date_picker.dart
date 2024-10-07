import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/utils/constants.dart';

class DatePickerForm extends StatelessWidget {
  const DatePickerForm({super.key, required this.dateController});
  final TextEditingController dateController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: dateController,
      decoration: InputDecoration(
        labelText: "Date of Arrival",
        hintText: "Pick a date",
        filled: true,
        fillColor: Colors.grey[800],
        labelStyle: AppConstants.subtitleTextStyle
            .copyWith(color: Colors.white, fontSize: 15),
        hintStyle: const TextStyle(color: Colors.white70),
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      },
    );
  }
}
