import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:myapp/providers/medium_buttons.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/my_textfield.dart';

class NewBatchPage extends ConsumerWidget {
  const NewBatchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batchNameController = TextEditingController();
    final dateController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          // Wrap the body in a SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize:
                  MainAxisSize.min, // Make the column take minimal height
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align to the start
              children: [
                // Text that says Start a new batch
                Text(
                  "Start a New Batch ",
                  style: AppConstants.titleTextStyle
                      .copyWith(color: Colors.white, fontSize: 24),
                ),
                // Subtitle text
                Text(
                  "Let's start with a new batch",
                  style: AppConstants.subtitleTextStyle
                      .copyWith(color: Colors.white, fontSize: 13),
                ),
                const Gap(50),
                // Batch Name field
                MyTextForm(
                  hintText: "Enter the Batch Name",
                  prefix: const Icon(Icons.edit),
                  controller: batchNameController,
                  obsecureText: false,
                ),

                const Gap(15),

                // Date picker field
                MyTextForm(
                  hintText: "Date of creation",
                  prefix: const Icon(Icons.date_range),
                  controller: dateController,
                  obsecureText: false,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      dateController.text = formattedDate;
                    }
                  },
                  readOnly: true, // Prevent manual text input
                ),

                const Gap(30),

                const MediumButtons(
                  text: "Create Batch",
                  icon: Icon(
                    Icons.add_circle_rounded,
                    color: Colors.white,
                  ),
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
