// File: batches_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/my_textfield.dart';
import 'package:myapp/services/api_services.dart';

class BatchesPage extends ConsumerStatefulWidget {
  const BatchesPage({super.key});

  @override
  _BatchesPageState createState() => _BatchesPageState();
}

class _BatchesPageState extends ConsumerState<BatchesPage> {
  final searchController = TextEditingController();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Using switch case to navigate to different pages
    switch (index) {
      case 0:
        Navigator.pushNamed(context, "/home");
        break;
      case 1:
        Navigator.pushNamed(context, "/greenHouse");
        break;
      case 2:
        Navigator.pushNamed(context, "/forecast");
        break;
      case 3:
        Navigator.pushNamed(context, "/settings");
        break;
      case 4:
        Navigator.pushNamed(context, "/report");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // 3 tabs: Active Batches, Completed, Add Batch
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstants.backgroundColor,
          title: Text(
            "View Your Batches",
            style: AppConstants.titleTextStyle
                .copyWith(color: Colors.white, fontSize: 17),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                // Open drawer or handle other functionality
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                icon: const Icon(
                  Icons.dashboard_outlined,
                  color: Colors.white,
                  size: 25,
                ),
                child: Text(
                  "Active Batches",
                  style: AppConstants.subtitleTextStyle
                      .copyWith(color: Colors.white, fontSize: 13),
                ),
              ),
              Tab(
                icon: const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 25,
                ),
                child: Text(
                  "Completed",
                  style: AppConstants.subtitleTextStyle
                      .copyWith(color: Colors.white, fontSize: 13),
                ),
              ),
              Tab(
                icon: const Icon(
                  Icons.add_circle,
                  color: Colors.white,
                  size: 25,
                ),
                child: Text(
                  "Add Batch",
                  style: AppConstants.subtitleTextStyle
                      .copyWith(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: AppConstants.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(20),
                child: MyTextForm(
                  hintText: "Search for batch name",
                  prefix: const Icon(Icons.search),
                  controller: searchController,
                  obsecureText: false,
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
                          Navigator.pushNamed(context, "/newBatch");
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
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Allows more than three items
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 14,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(size: 14, Icons.batch_prediction),
              label: 'All varieties',
            ),
            BottomNavigationBarItem(
              icon: Icon(size: 14, Icons.data_exploration),
              label: 'Forecast',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                size: 14,
                Icons.report,
              ),
              label: 'Report',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 33, 29, 29),
          onTap: _onItemTapped,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, "/arrivalData");
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // Helper function to build a batch list
  Widget _buildBatchList(BuildContext context, WidgetRef ref, String tab) {
    final batchListProvider =
        FutureProvider<List<Map<String, String>>>((ref) async {
      final apiService = ref.read(apiServiceProvider);
      final batches = await apiService.getBatches();
      return batches.map((batch) {
        return {
          "name": batch.name,
          "date": batch.createdAt.toString(),
        };
      }).toList();
    });

    return Consumer(
      builder: (context, ref, child) {
        final batchListAsyncValue = ref.watch(batchListProvider);

        return batchListAsyncValue.when(
          data: (batches) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemCount: batches.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text(
                    "${index + 1}.",
                    style: const TextStyle(color: Colors.white),
                  ),
                  title: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/greenHouse");
                    },
                    child: Text(
                      batches[index]["name"]!,
                      style: AppConstants.subtitleTextStyle
                          .copyWith(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  trailing: Text(
                    batches[index]["date"]!,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        );
      },
    );
  }
}
