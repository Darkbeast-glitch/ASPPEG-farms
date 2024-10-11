import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:myapp/providers/medium_buttons.dart';
import 'package:myapp/utils/batch_button.dart';
import 'package:myapp/utils/overview_card.dart';
import 'package:myapp/utils/upcoming_card.dart';
import 'package:myapp/services/api_services.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  int _activeBatches = 0; // State variable to store active batches count

  @override
  void initState() {
    super.initState();
    _fetchActiveBatchCount(); // Fetch the active batch count when the page loads
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex != index) {
      Navigator.pop(context);
    }

    // using switch case to navigate to different pages
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, "/existBatches");
        break;
      case 2:
        Navigator.pushNamed(context, "/existBatches");
        break;
    }
  }

  Future<void> _fetchActiveBatchCount() async {
    final apiService = ref.read(apiServiceProvider);
    int count = await apiService.getActiveBatchCount();
    setState(() {
      _activeBatches = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Temporary hardcoded values
    const userName = 'Rhoda';
    const plantsInGreenhouse = 0;
    const cutsDue = 0;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 33, 29, 29),
      appBar: AppBar(
        title: const Text(
          "ASPPEG ",
          style: TextStyle(
              fontFamily: "Product Sans Bold",
              fontSize: 17,
              color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/profile");
              },
              child: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 33, 29, 29),
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle drawer/menu open
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome message
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 100, // You can adjust the height as needed
                child: Stack(
                  children: [
                    // Image with opacity
                    Opacity(
                      opacity: 0.2, // Adjust opacity value as needed
                      child: Image.asset(
                        "assets/images/backImage.jpg",
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    // Text overlay
                    const Positioned(
                      top: 30, // Adjust positioning as needed
                      left: 60,
                      child: Text(
                        'Welcome, $userName!',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Product Sans Bold",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Start New Batch and View Existing Batches buttons
            BatchButton(
              text: "Start New Batch",
              icon: const Icon(
                Icons.add_circle_rounded,
                color: Colors.white,
                size: 20,
              ),
              onTap: () {
                Navigator.pushNamed(context, "/newBatch");
              },
            ),
            const Gap(10),
            BatchButton(
                onTap: () {
                  Navigator.pushNamed(context, "/existBatches");
                },
                text: "View Exisiting Batches",
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 20,
                )),

            const SizedBox(height: 30),

            // Production Overview
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Production Overview',
                  style: TextStyle(
                    color: Colors.green,
                    fontFamily: "Product Sans Bold",
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: const Color(0XFF494E4B),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  // Overview Cards with dynamic data
                  OverviewCard(
                    icon: Icons.batch_prediction,
                    label: 'Active Batches',
                    value: '$_activeBatches', // Display active batch count
                  ),
                  const Gap(5),
                  const OverviewCard(
                    icon: Icons.grass,
                    label: 'Plants in Greenhouse',
                    value: '$plantsInGreenhouse',
                  ),
                  const Gap(5),
                  const OverviewCard(
                    icon: Icons.warning,
                    label: 'Total Reproduction',
                    value: '$cutsDue',
                    iconColor: Colors.yellow,
                  ),
                  const SizedBox(
                      height: 16), // Optional spacing after the last card
                ],
              ),
            ),

            const Gap(15),

            // Report and Issue buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MediumButtons(
                  onTap: () {
                    Navigator.pushNamed(context, "/arrivalData");
                  },
                  text: "Report",
                  icon: const Icon(
                    Icons.edit_document,
                    color: Colors.white,
                  ),
                  color: const Color(0xFF363836),
                ),
                const Gap(10),
                const MediumButtons(
                    text: "Issue",
                    icon: Icon(
                      Icons.report_problem,
                      color: Colors.white,
                    ),
                    color: Colors.red),
              ],
            ),
            const SizedBox(height: 16),

            // Upcoming Actions section
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Upcoming Actions',
                  style: TextStyle(
                    color: Colors.green,
                    fontFamily: "Product Sans Bold",
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Example upcoming action card
            const UpcomingActionCard(
              actionTitle: '1st Cut - Bellevue',
              dueDate: '30th September',
              daysLeft: 3,
            ),
          ],
        ),
      ),
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 33, 29, 29),
        onTap: _onItemTapped,
      ),
    );
  }
}
