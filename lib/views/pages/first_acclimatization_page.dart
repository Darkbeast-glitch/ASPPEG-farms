import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:myapp/services/api_services.dart';
import 'package:myapp/utils/constants.dart';

class AcclimatizationPage extends ConsumerStatefulWidget {
  const AcclimatizationPage({super.key});

  @override
  _AcclimatizationPageState createState() => _AcclimatizationPageState();
}

class _AcclimatizationPageState extends ConsumerState<AcclimatizationPage> {
  final List<Map<String, TextEditingController>> _acclimatizationForms = [];
  List<Map<String, dynamic>> _availableVarieties =
      []; // Store ID and variety data
  bool _isLoading = false;
  bool _isLoadingVarietyData = false;

  @override
  void initState() {
    super.initState();
    _fetchAvailableVarieties(); // Fetch varieties when the page loads
    _addAcclimatizationForm(); // Add the first form
  }

  // Fetch varieties from the existing endpoint
  void _fetchAvailableVarieties() async {
    final apiService = ref.read(apiServiceProvider);
    setState(() {
      _isLoadingVarietyData = true;
    });

    // Fetch varieties from the existing endpoint
    final varieties = await apiService
        .getVarietyData(); // Use your existing variety fetching endpoint
    setState(() {
      _availableVarieties = varieties
          .map((variety) => {
                'name': variety['variety_name'],
                'total_left': variety['total_left'],
                'id': variety['id']
              })
          .toList();
      _isLoadingVarietyData = false;
    });
  }

  // Add a new set of forms for additional acclimatization entries
  void _addAcclimatizationForm() {
    setState(() {
      _acclimatizationForms.add({
        'variety': TextEditingController(),
        'quantity': TextEditingController(),
        'mortality': TextEditingController(),
        'totalLeft': TextEditingController(),
        'date': TextEditingController(),
        'transplantingDate': TextEditingController(),
      });
    });
  }

  // Calculate the Total Left
  void _calculateTotalLeft(int index) {
    final quantityController = _acclimatizationForms[index]['quantity'];
    final mortalityController = _acclimatizationForms[index]['mortality'];
    final totalLeftController = _acclimatizationForms[index]['totalLeft'];

    int quantity = int.tryParse(quantityController!.text) ?? 0;
    int mortality = int.tryParse(mortalityController!.text) ?? 0;
    int totalLeft = quantity - mortality;

    totalLeftController!.text = totalLeft.toString();
  }

  // Fetch the variety ID based on the selected variety name
  int _getVarietyId(String varietyName) {
    final selectedVariety = _availableVarieties.firstWhere(
      (variety) => variety['name'] == varietyName,
      orElse: () => {'id': 0},
    );
    return selectedVariety['id'] ?? 0;
  }

  Future<void> _saveAcclimatizationData() async {
    setState(() {
      _isLoading = true;
    });

    final apiService = ref.read(apiServiceProvider);

    for (var form in _acclimatizationForms) {
      // Fetch the variety_id based on the selected variety name
      final varietyId =
          _getVarietyId(form['variety']!.text); // Get the correct variety_id

      // Prepare the correct data payload
      final acclimatizationData = {
        'variety_id': varietyId, // integer
        'date': form['date']!.text, // string in ISO 8601 format
        'mortality': int.tryParse(form['mortality']!.text) ?? 0, // integer
        'transplanting_date':
            form['transplantingDate']!.text, // string in ISO 8601 format
        'quantity': int.tryParse(form['quantity']!.text) ??
            0, // integer (derived from total_left)
      };

      try {
        // Call the API to add acclimatization data
        await apiService.addAcclimatization(acclimatizationData);
      } catch (e) {
        // If an error occurs, display a snack bar with the error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });

    // Show a success SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Acclimatization data saved successfully.'),
        backgroundColor: Colors.green,
      ),
    );

    // After success, show the dialog
    _showNextStepDialog();
  }

  // Dialog to ask the user what they want to do next
  void _showNextStepDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("What's Next?"),
          content: const Text(
              "Would you like to continue with the 2nd Acclimatization or do it later?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to the 2nd Acclimatization page (replace with your actual route)
                Navigator.pushNamed(context, '/secondAcclimatization');
              },
              child: const Text("2nd Acclimatization"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to the home page (replace with your actual route)
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
          '1st Acclimatization',
          style: AppConstants.titleTextStyle
              .copyWith(color: Colors.white, fontSize: 17),
        ),
        backgroundColor: AppConstants.backgroundColor,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Before Transplanting",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontFamily: "Product Sans Regular",
                ),
              ),
              Text(
                  "Add all data for acclimatization before the transplant and proceed.",
                  style: AppConstants.subtitleTextStyle.copyWith(
                    color: Colors.green,
                    fontSize: 10,
                  )),
              const Gap(20),
              _isLoadingVarietyData
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _acclimatizationForms.length,
                      itemBuilder: (context, index) {
                        return _buildAcclimatizationForm(index);
                      },
                    ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveAcclimatizationData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: _addAcclimatizationForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add_circle_outline),
                        SizedBox(width: 5),
                        Text('Add more'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAcclimatizationForm(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Acclimatization Entry ${index + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: "Product Sans Bold",
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(10),
          _buildDatePicker(
            label: "Date",
            controller: _acclimatizationForms[index]['date']!,
          ),
          const Gap(10),
          _buildDropdown(
            label: "Add variety",
            value: _acclimatizationForms[index]['variety']!.text.isNotEmpty
                ? _acclimatizationForms[index]['variety']!.text
                : null,
            items: _availableVarieties,
            onChanged: (value) {
              // When variety is selected, fetch its total_left and set it in the quantity field
              setState(() {
                _acclimatizationForms[index]['variety']!.text = value ?? '';
                final selectedVariety = _availableVarieties.firstWhere(
                    (variety) => variety['name'] == value,
                    orElse: () => {});
                _acclimatizationForms[index]['quantity']!.text =
                    selectedVariety['total_left'].toString();
                _calculateTotalLeft(index);
              });
            },
          ),
          const Gap(10),
          _buildTextField(
            label: "Quantity Of variety",
            controller: _acclimatizationForms[index]['quantity']!,
            keyboardType: TextInputType.number,
            onChanged: () => _calculateTotalLeft(index),
          ),
          const Gap(10),
          _buildTextField(
            label: "Mortality (Optional)",
            controller: _acclimatizationForms[index]['mortality']!,
            keyboardType: TextInputType.number,
            onChanged: () => _calculateTotalLeft(index),
          ),
          const Gap(10),
          _buildDatePicker(
            label: "Transplanting Date",
            controller: _acclimatizationForms[index]['transplantingDate']!,
          ),
          const Gap(10),
          _buildTextField(
            label: "Total Left",
            controller: _acclimatizationForms[index]['totalLeft']!,
            enabled: false,
            onChanged: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<Map<String, dynamic>> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((Map<String, dynamic> item) {
        return DropdownMenuItem<String>(
          value: item['name'],
          child:
              Text(item['name'], style: const TextStyle(color: Colors.black)),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[700],
        hintText: label,
        hintStyle: const TextStyle(color: Colors.white60),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
    required Function()? onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[700],
        hintText: label,
        hintStyle: const TextStyle(color: Colors.white60),
        border: const OutlineInputBorder(),
      ),
      enabled: enabled,
      onChanged: (_) => onChanged!(),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[700],
        hintText: label,
        hintStyle: const TextStyle(color: Colors.white60),
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.white60),
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
}
