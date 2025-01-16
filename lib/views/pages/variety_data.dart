import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:myapp/services/api_services.dart';
import 'package:myapp/services/auth_services.dart';
import 'package:myapp/utils/constants.dart';

class VarietyDetailsPage extends ConsumerStatefulWidget {
  const VarietyDetailsPage({super.key});

  @override
  _VarietyDetailsPageState createState() => _VarietyDetailsPageState();
}

class _VarietyDetailsPageState extends ConsumerState<VarietyDetailsPage> {
  final List<Map<String, dynamic>> _varietyForms = [];
  List<String> _availableVarieties = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAvailableVarieties();
    _addVarietyForm();
  }

  void _fetchAvailableVarieties() async {
    final apiService = ref.read(apiServiceProvider);
    final varieties = await apiService.fetchVarietyNames();
    setState(() {
      _availableVarieties = varieties;
    });
  }

  void _addVarietyForm() {
    setState(() {
      _varietyForms.add({
        'variety': TextEditingController(),
        'quantity': TextEditingController(),
        'mortality': TextEditingController(),
        'totalLeft': TextEditingController(),
        'imageFile':
            null, // Ensure this is null or of type File, not TextEditingController
      });
    });
  }

  Future<void> _pickImage(int index) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _varietyForms[index]['imageFile'] = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _calculateTotalLeft(int index) {
    final quantityController =
        _varietyForms[index]['quantity'] as TextEditingController;
    final mortalityController =
        _varietyForms[index]['mortality'] as TextEditingController;
    final totalLeftController =
        _varietyForms[index]['totalLeft'] as TextEditingController;

    int quantity = int.tryParse(quantityController.text) ?? 0;
    int mortality = int.tryParse(mortalityController.text) ?? 0;
    int totalLeft = quantity - mortality;

    totalLeftController.text = totalLeft.toString();
  }

  bool _validateForms() {
    bool isValid = true;

    for (var form in _varietyForms) {
      if ((form['variety'] as TextEditingController).text.isEmpty ||
          (form['quantity'] as TextEditingController).text.isEmpty ||
          int.tryParse((form['quantity'] as TextEditingController).text) ==
              null ||
          (form['mortality'] as TextEditingController).text.isEmpty ||
          int.tryParse((form['mortality'] as TextEditingController).text) ==
              null) {
        isValid = false;
        break;
      }
    }

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields with valid data.'),
          backgroundColor: Colors.red,
        ),
      );
    }

    return isValid;
  }

  Future<void> _saveVarietyData() async {
    if (!_validateForms()) return;

    setState(() => _isLoading = true);

    try {
      final apiService = ref.read(apiServiceProvider);
      final authService = ref.read(authSerivceProvider);
      final firebaseUID = await authService.getIdToken();
      final fullName = await apiService.fetchUserFullName(firebaseUID!);

      for (var form in _varietyForms) {
        String? imageUrl;
        if (form['imageFile'] != null) {
          // Upload image first
          imageUrl =
              await apiService.uploadVarietyImage(form['imageFile'] as File);
          if (imageUrl == null) {
            throw Exception('Failed to upload image');
          }
        }

        final varietyData = {
          'batch_id': 1, // This will be replaced later with actual batch ID
          'variety_name': (form['variety'] as TextEditingController).text,
          'quantity':
              int.parse((form['quantity'] as TextEditingController).text),
          'mortality':
              int.parse((form['mortality'] as TextEditingController).text),
          'image_url': imageUrl,
          'created_by': fullName,
        };

        final success = await apiService.addVarietyData(varietyData);
        if (!success) {
          throw Exception('Variety Already exist');
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Variety data saved successfully'),
          backgroundColor: Colors.green,
        ),
      );

      _showNextStepDialog();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showNextStepDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: const Text(
            "What would you like to do next?",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "Would you like to continue with acclimatization or do it later?",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/addAcclimatization');
              },
              child: const Text("Continue with Acclimatization"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/home');
              },
              child: const Text("Do it Later"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Variety Details',
          style: AppConstants.titleTextStyle.copyWith(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
        backgroundColor: AppConstants.backgroundColor,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(15),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _varietyForms.length,
                itemBuilder: (context, index) {
                  return _buildVarietyForm(index);
                },
              ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveVarietyData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Save',
                            style: AppConstants.buttonTextStyle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                  ),
                  ElevatedButton(
                    onPressed: _addVarietyForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add_circle_outline),
                        const SizedBox(width: 8),
                        Text(
                          'Add more',
                          style: AppConstants.subtitleTextStyle.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVarietyForm(int index) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Variety Input ${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "Product Sans Bold",
              ),
            ),
            const Gap(15),
            GestureDetector(
              onTap: () => _pickImage(index),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[600]!),
                ),
                child: _varietyForms[index]['imageFile'] != null
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _varietyForms[index]['imageFile'] as File,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _varietyForms[index]['imageFile'] = null;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo,
                              color: Colors.white, size: 40),
                          SizedBox(height: 8),
                          Text(
                            'Tap to add variety image',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Product Sans Regular",
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const Gap(20),
            const Text(
              'Add variety',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: "Product Sans Regular",
              ),
            ),
            const Gap(8),
            DropdownButtonFormField<String>(
              value: (_varietyForms[index]['variety'] as TextEditingController)
                      .text
                      .isNotEmpty
                  ? (_varietyForms[index]['variety'] as TextEditingController)
                      .text
                  : null,
              items: _availableVarieties.map((String variety) {
                return DropdownMenuItem<String>(
                  value: variety,
                  child: Text(
                    variety,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "Product Sans Regular",
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  (_varietyForms[index]['variety'] as TextEditingController)
                      .text = value ?? '';
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[700],
                hintText: 'Select a Variety',
                hintStyle: const TextStyle(
                  color: Colors.white60,
                  fontFamily: "Product Sans Regular",
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const Gap(10),
            TextFormField(
              controller:
                  _varietyForms[index]['quantity'] as TextEditingController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[700],
                hintText: 'Quantity Of variety',
                hintStyle: const TextStyle(
                  color: Colors.white60,
                  fontFamily: "Product Sans Regular",
                ),
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => _calculateTotalLeft(index),
            ),
            const Gap(10),
            TextFormField(
              controller:
                  _varietyForms[index]['mortality'] as TextEditingController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[700],
                hintText: 'Mortality (Optional)',
                hintStyle: const TextStyle(
                  color: Colors.white60,
                  fontFamily: "Product Sans Regular",
                ),
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => _calculateTotalLeft(index),
            ),
            const Gap(10),
            TextFormField(
              controller:
                  _varietyForms[index]['totalLeft'] as TextEditingController,
              enabled: false,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[700],
                hintText: 'Total Left',
                hintStyle: const TextStyle(
                  color: Colors.white60,
                  fontFamily: "Product Sans Regular",
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
