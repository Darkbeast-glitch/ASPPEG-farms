import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:myapp/services/api_services.dart';
import 'package:myapp/utils/constants.dart';
import 'package:animate_do/animate_do.dart';

class SecondAcclimatizationPage extends ConsumerStatefulWidget {
  const SecondAcclimatizationPage({super.key});

  @override
  _SecondAcclimatizationPageState createState() =>
      _SecondAcclimatizationPageState();
}

class _SecondAcclimatizationPageState
    extends ConsumerState<SecondAcclimatizationPage> {
  final List<Map<String, TextEditingController>> _acclimatizationForms = [];
  List<Map<String, dynamic>> _availableVarieties = [];
  bool _isLoading = false;
  bool _isLoadingVarietyData = false;

  @override
  void initState() {
    super.initState();
    _fetchAvailableVarieties();
    _addAcclimatizationForm();
  }

  Future<void> _fetchAvailableVarieties() async {
    final apiService = ref.read(apiServiceProvider);

    setState(() {
      _isLoadingVarietyData = true;
    });

    try {
      final varieties = await apiService.getVarietyData();

      setState(() {
        _availableVarieties = varieties
            .map((variety) => {
                  'name': variety['variety_name'],
                  'total_left': variety['total_left'],
                  'id': variety['id']
                })
            .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching varieties: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoadingVarietyData = false;
      });
    }
  }

  void _addAcclimatizationForm() {
    setState(() {
      _acclimatizationForms.add({
        'variety': TextEditingController(),
        'quantity': TextEditingController(),
        'mortality': TextEditingController(),
        'totalLeft': TextEditingController(),
        'date': TextEditingController(),
      });
    });
  }

  void _calculateTotalLeft(int index) {
    final quantityController = _acclimatizationForms[index]['quantity'];
    final mortalityController = _acclimatizationForms[index]['mortality'];
    final totalLeftController = _acclimatizationForms[index]['totalLeft'];

    int quantity = int.tryParse(quantityController!.text) ?? 0;
    int mortality = int.tryParse(mortalityController!.text) ?? 0;
    int totalLeft = quantity - mortality;

    totalLeftController!.text = totalLeft.toString();
  }

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
      final varietyId = _getVarietyId(form['variety']!.text);

      final acclimatizationData = {
        'variety_id': varietyId,
        'date': form['date']!.text,
        'mortality': int.tryParse(form['mortality']!.text) ?? 0,
        'quantity': int.tryParse(form['quantity']!.text) ?? 0,
      };

      try {
        await apiService.addSecondAcclimatization(acclimatizationData);
      } catch (e) {
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Second Acclimatization data saved successfully.'),
        backgroundColor: Colors.green,
      ),
    );

    _showNextStepDialog();
  }

  void _showNextStepDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Continue with Cutting?"),
          content: const Text(
              "Would you like to continue with the cutting process or do it later?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/firstCut');
              },
              child: const Text("Continue with cutting"),
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
        elevation: 0,
        title: Text(
          '2nd Acclimatization',
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
                        "Second Phase",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Product Sans Bold",
                        ),
                      ),
                      const Gap(4),
                      Text(
                        "Add all data for the second acclimatization before proceeding to cutting.",
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
                child: _isLoadingVarietyData
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.green,
                        ),
                      )
                    : ListView.builder(
                        itemCount: _acclimatizationForms.length,
                        itemBuilder: (context, index) {
                          return FadeInUp(
                            delay: Duration(milliseconds: 100 * index),
                            child: _buildAcclimatizationForm(index),
                          );
                        },
                      ),
              ),
              const Gap(20),
              FadeInUp(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveAcclimatizationData,
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
                            : Text('Save Data',
                                style: AppConstants.subtitleTextStyle.copyWith(
                                    color: Colors.white, fontSize: 15)),
                      ),
                    ),
                    const Gap(12),
                    ElevatedButton(
                      onPressed: _addAcclimatizationForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700],
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAcclimatizationForm(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
      child: ExpansionTile(
        initiallyExpanded: true,
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Gap(12),
            Text(
              'Acclimatization Entry ${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: "Product Sans Bold",
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDatePicker(
                  label: "Date",
                  controller: _acclimatizationForms[index]['date']!,
                  icon: Icons.event,
                ),
                const Gap(16),
                _buildDropdown(
                  label: "Select Variety",
                  value:
                      _acclimatizationForms[index]['variety']!.text.isNotEmpty
                          ? _acclimatizationForms[index]['variety']!.text
                          : null,
                  items: _availableVarieties,
                  onChanged: (value) {
                    setState(() {
                      _acclimatizationForms[index]['variety']!.text =
                          value ?? '';
                      final selectedVariety = _availableVarieties.firstWhere(
                        (variety) => variety['name'] == value,
                        orElse: () => {},
                      );
                      _acclimatizationForms[index]['quantity']!.text =
                          selectedVariety['total_left'].toString();
                      _calculateTotalLeft(index);
                    });
                  },
                ),
                const Gap(16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: "Quantity",
                        controller: _acclimatizationForms[index]['quantity']!,
                        keyboardType: TextInputType.number,
                        onChanged: () => _calculateTotalLeft(index),
                        icon: Icons.numbers,
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: _buildTextField(
                        label: "Mortality",
                        controller: _acclimatizationForms[index]['mortality']!,
                        keyboardType: TextInputType.number,
                        onChanged: () => _calculateTotalLeft(index),
                        icon: Icons.remove_circle_outline,
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                _buildTextField(
                  label: "Total Left",
                  controller: _acclimatizationForms[index]['totalLeft']!,
                  enabled: false,
                  onChanged: () {},
                  icon: Icons.analytics_outlined,
                ),
                if (_acclimatizationForms.length > 1)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _acclimatizationForms.removeAt(index);
                        });
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text(
                        'Remove Entry',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
    required Function() onChanged,
    TextInputType keyboardType = TextInputType.text,
    IconData? icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[800],
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        prefixIcon: Icon(icon, color: Colors.white60),
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
      enabled: enabled,
      onChanged: (_) => onChanged(),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required TextEditingController controller,
    IconData? icon,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[800],
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        prefixIcon: Icon(icon, color: Colors.white60),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[700]!),
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
          child: Text(
            item['name'],
            style: const TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      dropdownColor: Colors.grey[850],
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[800],
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        prefixIcon: const Icon(Icons.local_florist, color: Colors.white60),
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
}
