import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/services/api_services.dart';
import 'package:myapp/utils/constants.dart';
import 'package:gap/gap.dart';
import 'package:animate_do/animate_do.dart';

class NewFieldDetailsPage extends ConsumerStatefulWidget {
  const NewFieldDetailsPage({super.key});

  @override
  _NewFieldDetailsPageState createState() => _NewFieldDetailsPageState();
}

class _NewFieldDetailsPageState extends ConsumerState<NewFieldDetailsPage> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _plotNumber = TextEditingController();
  final TextEditingController _mortalityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _fieldName = TextEditingController();
 

  List<Map<String, dynamic>> _availableVarieties = [];
  Map<String, dynamic>? _selectedVariety;
  bool _isLoading = false;
  bool _isLoadingVarieties = true;

  @override
  void initState() {
    super.initState();
    _fetchAvailableVarieties();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _plotNumber.dispose();
    _mortalityController.dispose();
    _dateController.dispose();
    _fieldName.dispose();
    super.dispose();
  }

  // Fetch varieties from the API
  Future<void> _fetchAvailableVarieties() async {
    final apiService = ref.read(apiServiceProvider);

    try {
      final varieties = await apiService.getVarietyData();
      setState(() {
        _availableVarieties = varieties
            .map((variety) => {
                  'id': variety['id'],
                  'name': variety['variety_name'],
                  'quantity': variety['quantity'] ??
                      0, // Ensure quantity has a default value if null
                })
            .toList();
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error fetching varieties: $e'),
            backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoadingVarieties = false;
      });
    }
  }

  void _onVarietySelected(Map<String, dynamic> variety) {
    setState(() {
      _selectedVariety = variety;
      _quantityController.text =
          variety['quantity']?.toString() ?? '0'; // Safely handle null values
    });
  }

  @override
 @override
Widget build(BuildContext context) {
  final arguments =
      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
  final varietyId = arguments?['id'] ?? 0;

  return Scaffold(
    backgroundColor: AppConstants.backgroundColor,
    appBar: AppBar(
      elevation: 0,
      title: Text(
        'Field Details',
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
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
      ),
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "First Reproduction Area",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Product Sans Bold",
                      ),
                    ),
                    const Gap(4),
                    Text(
                      "Record the details for First Reproduction Area",
                      style: AppConstants.subtitleTextStyle.copyWith(
                        color: Colors.green,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(20),
            Expanded(
              child: SingleChildScrollView(
                child: FadeInUp(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildVarietyDropdown(),
                        const Gap(16),
                        _buildTextField(
                          label: "Quantity",
                          controller: _quantityController,
                          enabled: false,
                          icon: Icons.inventory,
                        ),
                        const Gap(16),
                        _buildTextField(
                          label: "Plot Number",
                          controller: _plotNumber,
                          icon: Icons.inventory,
                        ),
                        const Gap(16),
                        _buildTextField(
                          label: "Field Name",
                          controller: _fieldName,
                          icon: Icons.inventory,
                        ),
                        const Gap(16),
                        _buildDatePicker(
                          label: "Date of Transplanting",
                          controller: _dateController,
                          icon: Icons.event,
                        ),
                        const Gap(16),
                        _buildTextField(
                          label: "Mortality",
                          controller: _mortalityController,
                          keyboardType: TextInputType.number,
                          icon: Icons.remove_circle_outline,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
           const Gap(20),
FadeInUp(
  child: SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: _isLoading ? null : _handleFieldDetailsSubmission,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
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
          : Text(
              'Save Field Details',
              style: AppConstants.subtitleTextStyle.copyWith(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
    ),
  ),
),
          ],
        ),
      ),
    ),
    floatingActionButton: SizedBox(
      width: 40,
      height: 40,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/home');
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.home, size: 30),
      ),
    ),
  );
}
  Widget _buildVarietyDropdown() {
    return _isLoadingVarieties
        ? const Center(child: CircularProgressIndicator())
        : DropdownButtonFormField<Map<String, dynamic>>(
            value: _selectedVariety,
            items: _availableVarieties.map((variety) {
              return DropdownMenuItem<Map<String, dynamic>>(
                value: variety,
                child: Text(
                  variety['name'],
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                _onVarietySelected(value);
              }
            },
            dropdownColor: Colors.grey[850],
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[800],
              labelText: "Select Variety",
              labelStyle: const TextStyle(color: Colors.white60),
              prefixIcon:
                  const Icon(Icons.local_florist, color: Colors.white60),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[700]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.green),
              ),
            ),
            style: const TextStyle(color: Colors.white),
          );
  }

 Future<void> _handleFieldDetailsSubmission() async {
  if (_selectedVariety == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select a variety.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  setState(() {
    _isLoading = true;
  });

  final apiService = ref.read(apiServiceProvider);
  final quantity = int.tryParse(_quantityController.text) ?? 0;
  final mortality = int.tryParse(_mortalityController.text) ?? 0;
  final date = _dateController.text;
  const createdBy = 'user_name'; // Replace with actual user name if needed

  final fieldDetails = {
    'variety_id': _selectedVariety!['id'],
    'plot_number': _plotNumber.text,
    'field_name': _fieldName.text,
    'date_of_transplanting': date,
    'quantity_left_after_first_cut': quantity,
    'mortality': mortality,
  };

  try {
    final success = await apiService.addFieldDetails(fieldDetails);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Field details saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      _showNextStepDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save field details.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
  void _showNextStepDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("What's Next?"),
          content: const Text(
              "Would you like to proceed to the Field Details or do it later?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/fieldDetails');
              },
              child: const Text("Go to 2nd Cut"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/firstReproduction');
              },
              child: const Text("FRA"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    bool enabled = true,
    final IconData? icon,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    Function()? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      enabled: enabled,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12, color: Colors.white),
        filled: true,
        fillColor: Colors.grey[700],
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
      ),
      onChanged: (_) => onChanged?.call(),
    );
  }

  Widget _buildDatePicker({
    required String label,
    final IconData? icon,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12, color: Colors.white),
        filled: true,
        fillColor: Colors.grey[700],
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.white),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() {
            controller.text = pickedDate.toIso8601String().split('T').first;
          });
        }
      },
    );
  }

  String _calculateWeek(DateTime date) {
    final startDate = DateTime(date.year, 1, 1);
    final difference = date.difference(startDate).inDays;
    return 'Week ${difference ~/ 7 + 1}';
  }

  // Other methods and widgets remain unchanged...
}
