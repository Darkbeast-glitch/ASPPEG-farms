import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/services/api_services.dart';
import 'package:myapp/utils/constants.dart';
import 'package:gap/gap.dart';
import 'package:animate_do/animate_do.dart';

class FieldDetailsPage extends ConsumerStatefulWidget {
  const FieldDetailsPage({super.key});

  @override
  _FieldDetailsPageState createState() => _FieldDetailsPageState();
}

class _FieldDetailsPageState extends ConsumerState<FieldDetailsPage> {
  final TextEditingController _varietyController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _plotNumberController = TextEditingController();
  final TextEditingController _fieldNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _mortalityController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _varietyController.dispose();
    _quantityController.dispose();
    _plotNumberController.dispose();
    _fieldNameController.dispose();
    _dateController.dispose();
    _mortalityController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmission() async {
    if (_dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a transplanting date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final apiService = ref.read(apiServiceProvider);

    final fieldData = {
      'variety': _varietyController.text,
      'quantity': int.tryParse(_quantityController.text) ?? 0,
      'plot_number': _plotNumberController.text,
      'field_name': _fieldNameController.text,
      'transplanting_date': _dateController.text,
      'mortality': int.tryParse(_mortalityController.text) ?? 0,
    };

    try {
      // await apiService.addFieldDetails(fieldData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Field details saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Field Details for First\nReproduction Area',
          textAlign: TextAlign.center,
          style: AppConstants.titleTextStyle.copyWith(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppConstants.backgroundColor,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInDown(
                        child: _buildTextField(
                          label: "Variety",
                          controller: _varietyController,
                          enabled: false,
                          hintText: "Auto-generate from take a cut record",
                        ),
                      ),
                      const Gap(16),
                      FadeInDown(
                        delay: const Duration(milliseconds: 100),
                        child: _buildTextField(
                          label: "Quantity",
                          controller: _quantityController,
                          hintText: "Quantity left after cut",
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const Gap(16),
                      FadeInDown(
                        delay: const Duration(milliseconds: 200),
                        child: _buildTextField(
                          label: "Plot Number",
                          controller: _plotNumberController,
                          hintText: "plot number",
                        ),
                      ),
                      const Gap(16),
                      FadeInDown(
                        delay: const Duration(milliseconds: 300),
                        child: _buildTextField(
                          label: "Field Name",
                          controller: _fieldNameController,
                          hintText: "which field is that",
                        ),
                      ),
                      const Gap(16),
                      FadeInDown(
                        delay: const Duration(milliseconds: 400),
                        child: _buildDatePicker(
                          label: "Date of transplanting",
                          controller: _dateController,
                          hintText: "dd/mm/yy",
                        ),
                      ),
                      const Gap(16),
                      FadeInDown(
                        delay: const Duration(milliseconds: 500),
                        child: _buildTextField(
                          label: "Mortality (Optional)",
                          controller: _mortalityController,
                          hintText: "Record any mortality before transplanting",
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(20),
              FadeInUp(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSubmission,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Send to First Reproduction Area',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Gap(8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[800],
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.green),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker({
    required String label,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Gap(8),
        TextFormField(
          controller: controller,
          readOnly: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[800],
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
            suffixIcon: Icon(
              Icons.calendar_today,
              color: Colors.grey[500],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.green),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      surface: Color(0xFF303030),
                      onSurface: Colors.white,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              setState(() {
                controller.text = pickedDate.toIso8601String().split('T').first;
              });
            }
          },
        ),
      ],
    );
  }
}
