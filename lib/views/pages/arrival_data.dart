
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gap/gap.dart';
import 'package:myapp/providers/medium_buttons.dart';
import 'package:myapp/services/api_services.dart'; // Import your API service
import 'package:myapp/utils/arrival_text_Form.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/date_picker.dart';

class ArrivalDataPage extends ConsumerStatefulWidget {
  const ArrivalDataPage({super.key});

  @override
  _ArrivalDataPageState createState() => _ArrivalDataPageState();
}

class _ArrivalDataPageState extends ConsumerState<ArrivalDataPage> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  // Controllers for form fields
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController mortalityController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController shippingCompanyController =
      TextEditingController();
  final TextEditingController acclimatizationDateController =
      TextEditingController();

  String selectedShippingMethod = 'Air';
  bool _isLoading = false;

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  // Function to handle form submission including image upload and data submission
  // Function to handle form submission including image upload and data submission
  Future<void> _submitArrivalData() async {
    setState(() {
      _isLoading = true;
    });

    final apiService = ref.read(apiServiceProvider);

    // Step 1: Upload the image if selected
    String? imagePath;
    if (_selectedImage != null) {
      imagePath = await apiService.uploadImage(_selectedImage!);
      if (imagePath == null) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image upload failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    // Step 2: Prepare arrival data and submit to the backend
    Map<String, dynamic> arrivalData = {
      "batch_id": 26, // Replace with the actual batch ID or get it dynamically
      "quantity_of_plant_arrived": int.tryParse(quantityController.text) ?? 0,
      "date_of_arrival": dateController.text,
      "mortality_rate": int.tryParse(mortalityController.text) ?? 0,
      "shipping_method": selectedShippingMethod,
      "shipping_company": shippingCompanyController.text,
      "image_path":
          imagePath ?? '', // Use the image URL obtained from the upload API
      "comment": commentController.text,
      "acclimatization_date": acclimatizationDateController.text,
    };

    bool success = await apiService.submitArrivalData(arrivalData);

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? 'Arrival data submitted successfully.'
            : 'Failed to submit arrival data.'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) {
      _showConfirmationDialog();
    }
  }

  // Function to show the confirmation dialog
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("What would you like to do next?"),
          content: const Text(
              "Would you like to continue entering variety or go back to the home page?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to the variety entry page (replace with your variety page route)
                Navigator.pushNamed(context, '/varietyData');
              },
              child: const Text("Enter Variety"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pop(context); // Go back to home or previous screen
              },
              child: const Text("Go Back Home"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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

                // Image upload field
                GestureDetector(
                  onTap:
                      _pickImage, // Call image picker when the container is tapped
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey[800],
                    child: _selectedImage == null
                        ? const Center(
                            child: Text('Tap to pick an image',
                                style: TextStyle(color: Colors.white)))
                        : Image.file(_selectedImage!, fit: BoxFit.cover),
                  ),
                ),
                const Gap(20),

                // Comment about the Image
                ArrivalTextForm(
                  type: TextInputType.text,
                  controller: commentController,
                  labelText: "Image Comment",
                  hintText: "Enter any comment about the image",
                  suffixicon: const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.white,
                  ),
                ),
                const Gap(20),

                // Quantity of Plant Arrived
                ArrivalTextForm(
                  type: const TextInputType.numberWithOptions(),
                  controller: quantityController,
                  labelText: "Quantity of Mother plants arrived",
                  hintText: "Enter the number of mother plant",
                  suffixicon: const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.white,
                  ),
                ),
                const Gap(20),

                // Date of Arrival
                DatePickerForm(
                    labelText: "Date of Arrival",
                    dateController: dateController),
                const Gap(20),

                // Mortality (Optional)
                ArrivalTextForm(
                    labelText: "Mortality (Optional)",
                    hintText: "This is optional",
                    controller: mortalityController,
                    suffixicon: const Icon(Icons.info_outline_rounded),
                    type: const TextInputType.numberWithOptions()),
                const Gap(20),

                // Shipping Method Dropdown
                DropdownButtonFormField<String>(
                  value: selectedShippingMethod,
                  items: ['Air', 'Truck']
                      .map((method) => DropdownMenuItem<String>(
                            value: method,
                            child: Text(
                              method,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedShippingMethod = value;
                      });
                    }
                  },
                  style: const TextStyle(color: Colors.white),
                  dropdownColor: const Color(0xFF1C1C1C),
                  decoration: const InputDecoration(
                    labelText: "Shipping Method",
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: "Select your Shipping Method",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
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
                DatePickerForm(
                    labelText: "Date for your first acclimatization",
                    dateController: acclimatizationDateController),
                const Gap(20),

                // Save Button
                Center(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : MediumButtons(
                          text: "Save",
                          icon: const Icon(Icons.save,
                              color: Colors.white, size: 25),
                          color: Colors.green,
                          onTap: _submitArrivalData,
                        ),
                ),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
