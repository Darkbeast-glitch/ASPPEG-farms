import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/services/api_services.dart';
import 'package:myapp/utils/constants.dart';

class FirstCutPage extends ConsumerStatefulWidget {
  const FirstCutPage({super.key});

  @override
  _FirstCutPageState createState() => _FirstCutPageState();
}

class _FirstCutPageState extends ConsumerState<FirstCutPage> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _quantityCutController = TextEditingController();
  final TextEditingController _mortalityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _weekController = TextEditingController();
  final TextEditingController _reproductionRateController =
      TextEditingController();
  final TextEditingController _totalLeftController = TextEditingController();
  final TextEditingController _cuttingDoneController =
      TextEditingController(text: "1"); // Default to 1

  bool _isLoading = false; // Track API request state

  @override
  void dispose() {
    _quantityController.dispose();
    _quantityCutController.dispose();
    _mortalityController.dispose();
    _dateController.dispose();
    _weekController.dispose();
    _reproductionRateController.dispose();
    _totalLeftController.dispose();
    _cuttingDoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final varietyId =
        arguments?['id'] ?? 0; // Get the variety ID or default to 0
    final varietyName =
        arguments?['name'] ?? 'Unknown Variety'; // Get the variety name
    final quantity = arguments?['quantity'] ?? 0; // Get the quantity

    _quantityController.text = quantity.toString();

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Take Cut Records',
          style: AppConstants.titleTextStyle
              .copyWith(color: Colors.white, fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: AppConstants.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                label: "Variety",
                initialValue: varietyName,
                enabled: false,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Quantity",
                controller: _quantityController,
                enabled: false,
              ),
              const SizedBox(height: 16),
              _buildDatePicker(
                label: "Date",
                controller: _dateController,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Week (Auto-generate based on date)",
                controller: _weekController,
                enabled: false,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Quantity Cut",
                controller: _quantityCutController,
                keyboardType: TextInputType.number,
                onChanged: _calculateTotalLeft,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Reproduction Rate (total_left / quantity)",
                controller: _reproductionRateController,
                enabled: false,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Mortality (Optional)",
                controller: _mortalityController,
                keyboardType: TextInputType.number,
                onChanged: _calculateTotalLeft,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Total Left (Quantity Cut - Mortality)",
                controller: _totalLeftController,
                enabled: false,
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () => _handleCutSubmission(varietyId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Choose Field Details for this cut',
                        style: AppConstants.subtitleTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleCutSubmission(int varietyId) async {
    setState(() {
      _isLoading = true;
    });

    final apiService = ref.read(apiServiceProvider);
    final quantityCut = int.tryParse(_quantityCutController.text) ?? 0;
    final mortality = int.tryParse(_mortalityController.text) ?? 0;
    final date = _dateController.text;
    final week = _weekController.text;
    final totalLeft = quantityCut - mortality;
    final reproductionRate = totalLeft > 0
        ? (totalLeft / (int.tryParse(_quantityController.text) ?? 1))
            .toStringAsFixed(2)
        : '0.00';
    const createdBy = 'user_name'; // Replace with actual user name if needed

    final cutData = {
      'variety_id': varietyId,
      'quantity_cut': quantityCut,
      'date': date,
      'week': week,
      'reproduction_rate': double.tryParse(reproductionRate) ?? 0.0,
      'mortality': mortality,
      'created_by': createdBy,
      'quantity': int.tryParse(_quantityController.text) ?? 0,
      'total_left': totalLeft,
    };

    try {
      final success = await apiService.addCutRecord(cutData);

      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cut record saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        _showNextStepDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save cut record.'),
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
              child: const Text("Go to Field Details"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/greenhouse');
              },
              child: const Text("Do it Later"),
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
            _weekController.text = _calculateWeek(pickedDate);
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

  void _calculateTotalLeft() {
    final quantityCut = int.tryParse(_quantityCutController.text) ?? 0;
    final mortality = int.tryParse(_mortalityController.text) ?? 0;
    final totalLeft = quantityCut - mortality;
    _totalLeftController.text = totalLeft.toString();

    final quantity = int.tryParse(_quantityController.text) ?? 1;
    final reproductionRate =
        totalLeft > 0 ? (totalLeft / quantity).toStringAsFixed(2) : "0.00";
    _reproductionRateController.text = reproductionRate;
  }
}
