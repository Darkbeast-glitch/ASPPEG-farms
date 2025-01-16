import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/batch_models.dart';
import 'package:myapp/providers/medium_buttons.dart';
import 'package:myapp/providers/select_batch_prvoider.dart';
import 'package:myapp/services/api_services.dart';
import 'package:myapp/utils/constants.dart';

class BatchSelectionPage extends ConsumerWidget {
  const BatchSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppConstants.backgroundColor,
                AppConstants.backgroundColor.withOpacity(0.8),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo container with shadow
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.work_outline_outlined,
                    size: 80,
                    color: AppConstants.primaryColor,
                  ),
                ),
                const SizedBox(height: 40),

                // Title with animation
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Text(
                          "What would you like to do?",
                          style: AppConstants.titleTextStyle.copyWith(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 50),

                // Create Batch Button
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: MediumButtons(
                    text: "Create a Batch",
                    color: Colors.green,
                    onTap: () {
                      Navigator.pushNamed(context, '/newBatch');
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Existing Batches Button
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () => _showBatchSelectionDialog(context, ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.folder_open, size: 24),
                        const SizedBox(width: 10),
                        Text(
                          "Continue To Existing Batches",
                          style: AppConstants.subtitleTextStyle.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showBatchSelectionDialog(
      BuildContext context, WidgetRef ref) async {
    final apiService = ref.read(apiServiceProvider);
    List<Batch>? batches = await apiService.getBatches();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 16,
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxHeight: 400),
            child: Column(
              children: [
                Text(
                  "Select a Batch",
                  style: AppConstants.titleTextStyle.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  // ignore: unnecessary_null_comparison
                  child: batches == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: batches.length,
                          itemBuilder: (context, index) {
                            final batch = batches[index];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: AppConstants.primaryColor,
                                  child: Text(
                                    batch.name[0].toUpperCase(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  batch.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  "Created on: ${batch.createdAt}",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                onTap: () {
                                  ref
                                      .read(selectedBatchProvider.notifier)
                                      .state = batch.name;
                                  ref
                                      .read(selectedBatchIdProvider.notifier)
                                      .state = batch.id;
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/home');
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
