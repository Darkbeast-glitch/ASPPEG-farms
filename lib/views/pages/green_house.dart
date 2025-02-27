import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/services/api_services.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/my_buttons.dart';

class GreenhousePage extends ConsumerStatefulWidget {
  const GreenhousePage({super.key});

  @override
  _GreenhousePageState createState() => _GreenhousePageState();
}

class _GreenhousePageState extends ConsumerState<GreenhousePage> {
  List<Map<String, dynamic>> _varietyData = [];
  bool _isLoading = true;

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchVarietyData(); // Fetch variety data on page load
  }

  Future<void> _fetchVarietyData() async {
    final apiService = ref.read(apiServiceProvider);
    try {
      final data = await apiService.getSecondAcclimatizationData();
      setState(() {
        _varietyData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Display an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppConstants.backgroundColor,
        appBar: AppBar(
          title: Text(
            'GreenHouse',
            style: AppConstants.titleTextStyle
                .copyWith(color: Colors.white, fontSize: 17),
          ),
          backgroundColor: Colors.black87,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                // Implement menu action
              },
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Search Bar
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.black54),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search for variety',
                                hintStyle: AppConstants.subtitleTextStyle
                                    .copyWith(fontSize: 13, color: Colors.grey),
                                border: InputBorder.none,
                              ),
                              onChanged: (query) {
                                // Implement search logic
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Record any Mortality button and "All Varieties" header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "All Varieties",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to Record Mortality page
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.primaryColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Record any Mortality",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Product Sans Regular"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // List of varieties
                    Expanded(
                      child: ListView.builder(
                        itemCount: _varietyData.length,
                        itemBuilder: (context, index) {
                          final variety = _varietyData[index];
                          return Card(
                            color: const Color(0XFF2E2E2E),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Variety:  ${variety['variety']['variety_name']}',
                                        style: const TextStyle(
                                            color: Color(0xFFD19806),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Product Sans Regular"),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Quantity: ${variety['quantity']}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontFamily: "Product Sans Regular"),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Mortality:    ${variety['mortality']}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontFamily: "Product Sans Regular"),
                                  ),
                                  const SizedBox(height: 2),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Arrival Date: ${variety['variety']['created_at'] != null ? variety['variety']['created_at'].split("T").first : 'N/A'}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontFamily: "Product Sans Regular"),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Number of Cut Done:    ${variety['cut_done'] ?? 0}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontFamily: "Product Sans Regular"),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Created By: ${variety['created_by']}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontFamily: "Product Sans Regular"),
                                  ),
// put the button here to  make a cut here 
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: _buildBottomNavbar());
  }

  // Widget _buildVarietyCard(Map<String, dynamic> variety) {
  //   return Card(
  //     color = const Color(0XFF2E2E2E),
  //     shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //     margin = const EdgeInsets.symmetric(vertical: 8),
  //     child = Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 'Variety:  ${variety['variety_name']}',
  //                 style: const TextStyle(
  //                     color: Color(0xFFD19806),
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.bold,
  //                     fontFamily: "Product Sans Regular"),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 2),
  //           Text(
  //             'Quantity: ${variety['quantity']}',
  //             style: const TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 13,
  //                 fontFamily: "Product Sans Regular"),
  //           ),
  //           const SizedBox(height: 2),
  //           Text(
  //             'Mortality:    ${variety['mortality']}',
  //             style: const TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 13,
  //                 fontFamily: "Product Sans Regular"),
  //           ),
  //           const SizedBox(height: 2),
  //           Text(
  //             'Arrival Date: ${variety['created_at'].split("T").first}',
  //             style: const TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 13,
  //                 fontFamily: "Product Sans Regular"),
  //           ),
  //           const SizedBox(height: 2),
  //           Text(
  //             'Number of Cut Done:    ${variety['cut_done'] ?? 0}',
  //             style: const TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 13,
  //                 fontFamily: "Product Sans Regular"),
  //           ),
  //           const SizedBox(height: 2),
  //           Text(
  //             'Created By: ${variety['created_by']}',
  //             style: const TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 13,
  //                 fontFamily: "Product Sans Regular"),
  //           ),
  //           const SizedBox(height: 10),
  //           SizedBox(
  //             width: 100,
  //             height: 30,
  //             child: ElevatedButton(
  //               onPressed: () {
  //                 // Navigate to the First Cut Page with the variety data
  //                 Navigator.pushNamed(
  //                   context,
  //                   '/firstCut',
  //                   arguments: {
  //                     'name': variety['variety_name'], // Pass the variety name
  //                     'quantity': variety['quantity'], // Pass the quantity
  //                   },
  //                 );
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: Colors.green,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(50),
  //                 ),
  //               ),
  //               child: Text(
  //                 "Make a Cut",
  //                 style: AppConstants.subtitleTextStyle.copyWith(
  //                   color: Colors.white,
  //                   fontSize: 10,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  BottomNavigationBar _buildBottomNavbar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
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
          label: 'GreenHouse',
        ),
        BottomNavigationBarItem(
          icon: Icon(size: 14, Icons.data_exploration),
          label: 'Prduction',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            size: 14,
            Icons.report,
          ),
          label: 'Report',
        ),
      ],
      // currentIndex: _selectedIndex,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 33, 29, 29),
      // onTap: _onItemTapped,
    );
  }
}
