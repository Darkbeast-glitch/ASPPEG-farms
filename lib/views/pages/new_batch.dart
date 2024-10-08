import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:myapp/providers/medium_buttons.dart';
import 'package:myapp/services/api_services.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/my_textfield.dart';
import 'package:myapp/views/pages/arrival_data.dart';

class NewBatchScreen extends ConsumerStatefulWidget {
  const NewBatchScreen({super.key});

  @override
  _NewBatchScreenState createState() => _NewBatchScreenState();
}

class _NewBatchScreenState extends ConsumerState<NewBatchScreen> {
  final _batchNameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _batchNameController.dispose();
    super.dispose();
  }

  Future<void> _createBatch() async {
    // Get the ApiService from the provider
    final apiService = ref.read(apiServiceProvider);

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Call the API to create a new batch
      await apiService.createBatch(_batchNameController.text);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Batch created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear the input field
      _batchNameController.clear();

      // Navigate to the target page after successful batch creation
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const ArrivalDataPage(), // Replace with your actual target screen
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to create batch: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
      ),
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title text
                Text(
                  "Start a New Batch ",
                  style: AppConstants.titleTextStyle
                      .copyWith(color: Colors.white, fontSize: 24),
                ),
                // Subtitle text
                Text(
                  "Let's start with a new batch",
                  style: AppConstants.subtitleTextStyle
                      .copyWith(color: Colors.white, fontSize: 13),
                ),
                const Gap(50),
                // Batch Name input field
                MyTextForm(
                  hintText: "Enter the Batch Name",
                  prefix: const Icon(Icons.edit),
                  controller: _batchNameController,
                  obsecureText: false,
                ),
                const Gap(15),
                // Create Batch Button or Loading Indicator
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : MediumButtons(
                        text: "Create Batch",
                        color: Colors.green,
                        onTap: _createBatch,
                      ),
                if (_errorMessage != null) ...[
                  const Gap(15),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
