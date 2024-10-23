import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/batch_models.dart';
import 'package:myapp/providers/select_batch_prvoider.dart';
import 'package:myapp/services/api_services.dart';

class BatchSelectionPage extends ConsumerWidget {
  const BatchSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Logo.png',
                width: 100), // Replace with your logo
            const SizedBox(height: 20),
            const Text(
              "What would you like to do?",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                    context, '/newBatch'); // Navigate to create a new batch
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(200, 50),
              ),
              child: const Text("Create a Batch"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showBatchSelectionDialog(
                    context, ref); // Show dialog for selecting batch
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(200, 50),
              ),
              child: const Text("Continue To Existing Batches"),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show the batch selection dialog
  Future<void> _showBatchSelectionDialog(
      BuildContext context, WidgetRef ref) async {
    final apiService = ref.read(apiServiceProvider);
    List<Batch>? batches =
        await apiService.getBatches(); // Fetch batches from API

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select a Batch"),
          content: SizedBox(
            width: double.maxFinite,
            // ignore: unnecessary_null_comparison
            child: batches == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: batches.length,
                    itemBuilder: (context, index) {
                      final batch = batches[index];
                      return ListTile(
                        title: Text(
                            batch.name), // Accessing properties of Batch object
                        subtitle: Text(
                            "Created on: ${batch.createdAt}"), // Access Batch properties
                        onTap: () {
                          // Set the selected batch name and ID globally
                          ref.read(selectedBatchProvider.notifier).state =
                              batch.name;
                          ref.read(selectedBatchIdProvider.notifier).state =
                              batch.id;

                          Navigator.pop(context); // Close dialog
                          Navigator.pushNamed(
                              context, '/home'); // Navigate to the home page
                        },
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
