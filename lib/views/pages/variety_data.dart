import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:myapp/services/api_services.dart';
import 'package:myapp/services/auth_services.dart';
import 'package:myapp/utils/constants.dart'; // Import AuthService to handle Firebase UID

class VarietyDetailsPage extends ConsumerStatefulWidget {
  const VarietyDetailsPage({super.key});

  @override
  _VarietyDetailsPageState createState() => _VarietyDetailsPageState();
}

class _VarietyDetailsPageState extends ConsumerState<VarietyDetailsPage> {
  final List<Map<String, TextEditingController>> _varietyForms = [];
  List<String> _availableVarieties = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAvailableVarieties(); // Fetch the list of varieties on page load
    _addVarietyForm(); // Add the initial form
  }

  void _fetchAvailableVarieties() async {
    final apiService = ref.read(apiServiceProvider);
    final varieties = await apiService
        .fetchVarietyNames(); // Use the new method to fetch variety names
    setState(() {
      _availableVarieties =
          varieties; // Assign the fetched variety names to the dropdown options
    });
  }

  void _addVarietyForm() {
    setState(() {
      _varietyForms.add({
        'variety': TextEditingController(),
        'quantity': TextEditingController(),
        'mortality': TextEditingController(),
        'totalLeft': TextEditingController(),
      });
    });
  }

  void _calculateTotalLeft(int index) {
    final quantityController = _varietyForms[index]['quantity'];
    final mortalityController = _varietyForms[index]['mortality'];
    final totalLeftController = _varietyForms[index]['totalLeft'];

    int quantity = int.tryParse(quantityController!.text) ?? 0;
    int mortality = int.tryParse(mortalityController!.text) ?? 0;
    int totalLeft = quantity - mortality;

    totalLeftController!.text = totalLeft.toString();
  }

  // Function to validate all the forms
  bool _validateForms() {
    bool isValid = true;

    for (var form in _varietyForms) {
      if (form['variety']!.text.isEmpty || // Check if variety is selected
          form['quantity']!.text.isEmpty || // Check if quantity is entered
          int.tryParse(form['quantity']!.text) ==
              null || // Check if quantity is a valid number
          form['mortality']!.text.isEmpty || // Check if mortality is entered
          int.tryParse(form['mortality']!.text) == null) {
        // Check if mortality is a valid number
        isValid = false;
        break;
      }
    }

    if (!isValid) {
      // Show a snack bar to inform the user that the form is incomplete
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
    // Validate all forms before submitting
    if (!_validateForms()) {
      return; // If validation fails, stop the form submission process
    }

    setState(() {
      _isLoading = true;
    });

    final apiService = ref.read(apiServiceProvider);
    final authService = ref.read(authSerivceProvider);
    final firebaseUID = await authService.getIdToken(); // Get the Firebase UID
    final fullName = await apiService.fetchUserFullName(firebaseUID!);

    for (var form in _varietyForms) {
      final varietyData = {
        'batch_id': 26, // Replace with actual batch ID
        'variety_name': form['variety']!.text,
        'quantity': int.tryParse(form['quantity']!.text) ?? 0,
        'mortality': int.tryParse(form['mortality']!.text) ?? 0,
        'created_by': fullName, // Use the full name retrieved from the backend
      };
      await apiService.addVarietyData(varietyData);
    }

    setState(() {
      _isLoading = false;
    });

    // Show a success SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Variety data saved successfully.'),
        backgroundColor: Colors.green,
      ),
    );

    // Show a confirmation dialog to ask what the user wants to do next
    _showNextStepDialog();
  }

  // Function to show the confirmation dialog
  void _showNextStepDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("What would you like to do next?"),
          content: const Text(
              "Would you like to continue with acclimatization or do it later?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to the acclimatization page (replace with your acclimatization route)
                Navigator.pushNamed(context, '/addAcclimatization');
              },
              child: const Text("Continue with Acclimatization"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to the home page (replace with your home page route)
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
                    onPressed: _saveVarietyData, // Save button logic
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('Save',
                            style: AppConstants.buttonTextStyle
                                .copyWith(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: _addVarietyForm,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700]),
                    child: Row(
                      children: [
                        const Icon(Icons.add_circle_outline),
                        const SizedBox(width: 5),
                        Text(
                          'Add more',
                          style: AppConstants.subtitleTextStyle
                              .copyWith(color: Colors.white),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Variety Input ${index + 1}',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "Product Sans Bold"),
          ),
          const Gap(10),
          const Text('Add variety',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: "Product Sans Regular")),
          const Gap(8),
          DropdownButtonFormField<String>(
            value: _varietyForms[index]['variety']!.text.isNotEmpty
                ? _varietyForms[index]['variety']!.text
                : null,
            items: _availableVarieties.map((String variety) {
              return DropdownMenuItem<String>(
                value: variety,
                child: Text(variety,
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: "Product Sans Regular")),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _varietyForms[index]['variety']!.text = value ?? '';
              });
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[700],
              hintText: 'Select a Variety',
              hintStyle: const TextStyle(
                  color: Colors.white60, fontFamily: "Product Sans Regular"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const Gap(10),
          TextFormField(
            controller: _varietyForms[index]['quantity'],
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[700],
              hintText: 'Quantity Of variety',
              hintStyle: const TextStyle(
                  color: Colors.white60, fontFamily: "Product Sans Regular"),
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => _calculateTotalLeft(index),
          ),
          const Gap(10),
          TextFormField(
            controller: _varietyForms[index]['mortality'],
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[700],
              hintText: 'Mortality (Optional)',
              hintStyle: const TextStyle(
                  color: Colors.white60, fontFamily: "Product Sans Regular"),
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => _calculateTotalLeft(index),
          ),
          const Gap(10),
          TextFormField(
            controller: _varietyForms[index]['totalLeft'],
            enabled: false,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[700],
              hintText: 'Total Left',
              hintStyle: const TextStyle(
                  color: Colors.white60, fontFamily: "Product Sans Regular"),
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
