import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/services/api_services.dart';
import 'package:myapp/utils/constants.dart';
import 'package:gap/gap.dart';
import 'package:animate_do/animate_do.dart';

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
      TextEditingController(text: "1");

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
    _quantityCutController.dispose();
    _mortalityController.dispose();
    _dateController.dispose();
    _weekController.dispose();
    _reproductionRateController.dispose();
    _totalLeftController.dispose();
    _cuttingDoneController.dispose();
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
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final varietyId = arguments?['id'] ?? 0;

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'First Cut Records',
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
                        "Cutting Process",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Product Sans Bold",
                        ),
                      ),
                      const Gap(4),
                      Text(
                        "Record the details of your first cut for tracking and analysis.",
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
                            label: "Initial Quantity",
                            controller: _quantityController,
                            enabled: false,
                            icon: Icons.inventory,
                          ),
                          const Gap(16),
                          _buildDatePicker(
                            label: "Cut Date",
                            controller: _dateController,
                            icon: Icons.event,
                          ),
                          const Gap(16),
                          _buildTextField(
                            label: "Week",
                            controller: _weekController,
                            enabled: false,
                            icon: Icons.calendar_view_week,
                          ),
                          const Gap(16),
                          _buildTextField(
                            label: "Quantity Cut",
                            controller: _quantityCutController,
                            keyboardType: TextInputType.number,
                            onChanged: _calculateTotalLeft,
                            icon: Icons.content_cut,
                          ),
                          const Gap(16),
                          _buildTextField(
                            label: "Reproduction Rate",
                            controller: _reproductionRateController,
                            enabled: false,
                            icon: Icons.trending_up,
                          ),
                          const Gap(16),
                          _buildTextField(
                            label: "Mortality",
                            controller: _mortalityController,
                            keyboardType: TextInputType.number,
                            onChanged: _calculateTotalLeft,
                            icon: Icons.remove_circle_outline,
                          ),
                          const Gap(16),
                          _buildTextField(
                            label: "Total Left",
                            controller: _totalLeftController,
                            enabled: false,
                            icon: Icons.analytics_outlined,
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
                    onPressed:
                        _isLoading ? null : () => _handleCutSubmission(43),
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
                            'Save Cut Details',
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
      'second_acclimatization_id': 10,
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
  // Other methods and widgets remain unchanged...
}
