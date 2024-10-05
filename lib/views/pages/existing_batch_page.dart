import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:myapp/utils/constants.dart'; // Assuming you have a constants file for colors and text styles

class BatchesPage extends ConsumerWidget {
  const BatchesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3, // 3 tabs: Active Batches, Completed, Add Batch
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              AppConstants.backgroundColor, // Use your own color here
          title: const Text("View Your Batches"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // Open drawer or handle other functionality
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.folder_open), text: "Active Batches"),
              Tab(icon: Icon(Icons.check_circle), text: "Completed"),
              Tab(icon: Icon(Icons.add_circle), text: "Add Batch"),
            ],
          ),
        ),
        backgroundColor: AppConstants.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.black),
                      Gap(10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search for batch name",
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Tab Bar View
              Expanded(
                child: TabBarView(
                  children: [
                    // Active Batches Tab
                    _buildBatchList(context, ref, "Active Batches"),
                    // Completed Batches Tab
                    _buildBatchList(context, ref, "Completed Batches"),
                    // Add Batch Tab (Placeholder)
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to Add Batch page
                        },
                        child: const Text("Add New Batch"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Bottom Navigation Bar
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.batch_prediction),
              label: 'Batches',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: 1, // Highlight the Batches tab
          onTap: (index) {
            // Handle tab changes here
          },
        ),
      ),
    );
  }

  // Helper function to build a batch list
  Widget _buildBatchList(BuildContext context, WidgetRef ref, String tab) {
    final List<Map<String, String>> batches = [
      {"name": "Cephas", "date": "January 1 2024"},
      {"name": "Julius", "date": "January 1 2024"},
      {"name": "Rhoda", "date": "January 1 2024"},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: batches.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text(
                    "${index + 1}.",
                    style: const TextStyle(color: Colors.white),
                  ),
                  title: Text(
                    batches[index]["name"]!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: Text(
                    batches[index]["date"]!,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
