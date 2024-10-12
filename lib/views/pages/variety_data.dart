import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:myapp/services/api_services.dart';
import 'package:myapp/services/auth_services.dart'; // Import AuthService to handle Firebase UID

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

  Future<void> _saveVarietyData() async {
    setState(() {
      _isLoading = true;
    });

    final apiService = ref.read(apiServiceProvider);
    final authService = ref.read(authSerivceProvider);
    final firebaseUID = await authService.getIdToken(); // Get the Firebase UID
    final fullName = await apiService.fetchUserFullName(firebaseUID!);

    for (var form in _varietyForms) {
      final varietyData = {
        'batch_id': 1, // Replace with actual batch ID
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Variety Details'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Variety Details",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
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
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: _addVarietyForm,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen),
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
              const Gap(20),
              const Center(
                child: Column(
                  children: [
                    Icon(Icons.celebration, color: Colors.green, size: 50),
                    Gap(10),
                    Text(
                      'Variety added Successfully',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
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
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Gap(10),
          const Text('Add variety',
              style: TextStyle(color: Colors.white, fontSize: 14)),
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
              hintStyle: const TextStyle(color: Colors.white60),
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
              hintStyle: const TextStyle(color: Colors.white60),
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
              hintStyle: const TextStyle(color: Colors.white60),
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
              hintStyle: const TextStyle(color: Colors.white60),
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
