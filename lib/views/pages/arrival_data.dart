import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:myapp/providers/medium_buttons.dart';
import 'package:myapp/utils/arrival_text_Form.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/date_picker.dart';

class ArrivalDataPage extends ConsumerWidget {
  const ArrivalDataPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Controllers for form fields
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    final TextEditingController mortalityController = TextEditingController();
    final TextEditingController shippingMethodController =
        TextEditingController();
    final TextEditingController shippingCompanyController =
        TextEditingController();
    final TextEditingController acclimatizationDateController =
        TextEditingController();

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
        title: Text(
          "Arrival Data",
          style: AppConstants.titleTextStyle
              .copyWith(color: Colors.white, fontSize: 17),
        ),
        centerTitle: true,
      ),
      backgroundColor:
          const Color(0xFF1C1C1C), // Background color from the image
      body: SafeArea(
        child: SingleChildScrollView(
          // Scrolls the body when the screen size is insufficient
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Take Your Arrival Data",
                    style: AppConstants.seconTitleTextStyle
                        .copyWith(color: Colors.white, fontSize: 16)),
                const Gap(30),
                // Quantity of Plant Arrived
                ArrivalTextForm(
                  controller: quantityController,
                  labelText: "Quantity of Plant Arrived",
                  hintText: "Enter the number of mother plant",
                  suffixicon: const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.white,
                  ),
                ),

                const Gap(20),

                // Date of Arrival
                DatePickerForm(
                  dateController: dateController,
                ),
                const Gap(20),

                // Mortality (Optional)
                ArrivalTextForm(
                  labelText: "Mortality (Optional)",
                  hintText: "This is optional",
                  controller: mortalityController,
                  suffixicon: const Icon(Icons.info_outline_rounded),
                ),

                const Gap(20),

                // Shipping Method
                ArrivalTextForm(
                  labelText: "Shipping Method",
                  hintText: "Select your Shipping Method",
                  controller: shippingMethodController,
                  suffixicon: const Icon(
                    Icons.local_shipping,
                    color: Colors.white,
                  ),
                ),

                const Gap(20),

                // Shipping Company
                ArrivalTextForm(
                  labelText: "Shipping Company",
                  hintText: "What's the shipping Company",
                  controller: shippingCompanyController,
                  suffixicon: const Icon(
                    Icons.local_shipping_sharp,
                    color: Colors.white,
                  ),
                ),

                const Gap(20),

                // First Acclimatization Date
                ArrivalTextForm(
                    labelText: "When is your First acclimatization Date",
                    hintText: "In 14 Days",
                    controller: acclimatizationDateController,
                    suffixicon: const Icon(
                      Icons.date_range,
                      color: Colors.white,
                    )),

                const Gap(30),

                // Save Button
                const Center(
                    child: MediumButtons(
                        text: "Save",
                        icon: Icon(
                          Icons.save,
                          color: Colors.white,
                          size: 25,
                        ),
                        color: Colors.green)),

                const Gap(20),

                // Link for variety details
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Handle navigation to variety details
                    },
                    child: Text("Continue with Variety Details",
                        style: AppConstants.subtitleTextStyle
                            .copyWith(color: Colors.blue)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.timeline),
      //       label: 'Cycle',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.cloud),
      //       label: 'Forecast',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.report),
      //       label: 'Report',
      //     ),
      //   ],
      //   currentIndex: 0, // Assuming Home is selected
      //   selectedItemColor: Colors.green,
      //   unselectedItemColor: Colors.white,
      //   backgroundColor: const Color(0xFF1C1C1C), // Matches background color
      //   onTap: (index) {
      //     // Handle bottom navigation
      //   },
      // ),
    );
  }
}
