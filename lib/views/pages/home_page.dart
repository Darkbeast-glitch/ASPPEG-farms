import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:myapp/providers/medium_buttons.dart';
import 'package:myapp/providers/select_batch_prvoider.dart';
import 'package:myapp/services/api_services.dart';
import 'package:myapp/services/auth_services.dart';
import 'package:myapp/utils/batch_button.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/overview_card.dart';
import 'package:myapp/utils/upcoming_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  int _activeBatches = 0;

  @override
  void initState() {
    super.initState();
    _fetchActiveBatchCount(); // Fetch active batch count
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to different pages based on bottom nav index
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

  Future<void> _fetchActiveBatchCount() async {
    final apiService = ref.read(apiServiceProvider);
    int count = await apiService.getActiveBatchCount();
    setState(() {
      _activeBatches = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the selected batch from the global provider
    final selectedBatch = ref.watch(selectedBatchProvider);
    final userAuthProvider = ref.read(authServiceProvider);

    // Temporary hardcoded values
    // const userName = 'Julius';
    const userEmail = 'bbjulius900@gmail.com';
    const plantsInGreenhouse = 2000;
    const cutsDue = 10000;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 33, 29, 29),
      appBar: AppBar(
        title: const Text(
          "ASPPEG",
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
               onTap: () async {
              try {
                await userAuthProvider.signOut();
                Navigator.of(context).pushReplacementNamed('/login');
                ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error signing out: $e')),
                );
              }
               },
                 
               child: const Icon(
                 Icons.logout,
                 color: Colors.white,
               ),
             ),
           ),
         ],
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 33, 29, 29),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: _buildDrawer(userEmail, context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Displaying the currently selected batch
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 100,
                child: Stack(
                  children: [
                    Opacity(
                      opacity: 0.2,
                      child: Image.asset(
                        "assets/images/backImage.jpg",
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Product Sans Bold",
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                    ),
                    // Display the currently selected batch
                    Positioned(
                      top: 50,
                      left: 120,
                      child: Text(
                          selectedBatch != null
                              ? 'Current Batch: $selectedBatch'
                              : 'No Batch Selected',
                          style: AppConstants.subtitleTextStyle.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            BatchButton(
              text: "Start Process",
              icon: const Icon(
                Icons.add_circle_rounded,
                color: Colors.white,
                size: 20,
              ),
              onTap: () {
                Navigator.pushNamed(context, "/arrivalData");
              },
            ),
            const Gap(10),
            BatchButton(
                onTap: () {
                  Navigator.pushNamed(context, "/existBatches");
                },
                text: "View Existing Batches",
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 20,
                )),
            const SizedBox(height: 30),
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
                  OverviewCard(
                    icon: Icons.batch_prediction,
                    label: 'Active Batches',
                    value: '$_activeBatches',
                  ),
                  const Gap(5),
                   OverviewCard(
                    icon: Icons.add_circle_rounded,
                    label: 'Add Custom Reproduction Area',
                    onTap: (){
                      Navigator.pushNamed(context, "/fieldDetails");
                    },
                  ),
                  const Gap(5),
                   OverviewCard(
                    onTap: (){
                      Navigator.pushNamed(context, "/greenHouse");
                    },
                    icon: Icons.house,
                    label: 'Go to GreenHouse',
                    iconColor: Colors.green,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const Gap(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MediumButtons(
                  onTap: () {
                    Navigator.pushNamed(context, "/reportPage");
                  },
                  text: "Report",
                  icon: const Icon(
                    Icons.edit_document,
                    color: Colors.white,
                  ),
                  color: const Color(0xFF363836),
                ),
                const Gap(10),
                MediumButtons(
                    onTap: () {
                      Navigator.pushNamed(context, "/reportPage");
                    },
                    text: "Issue",
                    icon: const Icon(
                      Icons.report_problem,
                      color: Colors.white,
                    ),
                    color: Colors.red),
              ],
            ),

            const Gap(20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Upcoming Actions',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Product Sans Bold",
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            CarouselSlider(
              options: CarouselOptions(
                height: 100.0,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 0.8,
                
              ),
              items: [
                const UpcomingActionCard(
                  actionTitle: '1st Cut - Bellevue',
                  dueDate: '30th September',
                  daysLeft: 3,
                ),
                const UpcomingActionCard(
                  actionTitle: '2nd Cut - Murasaki',
                  dueDate: '5th October',
                  daysLeft: 8,
                ),
                const UpcomingActionCard(
                  actionTitle: '3rd Cut - Bellevue',
                  dueDate: '10th October',
                  daysLeft: 13,
                ),
              ].map((card) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 1.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: card,
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavbar(),
    );
  }

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
          label: 'Production',
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
    );
  }

  Widget _buildDrawer(String userEmail, BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 33, 29, 29),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(userEmail),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/user_avatar.jpg'),
            ),
            accountName: const Text("Hi Asppeg"),
            decoration: const BoxDecoration(
              color: Colors.black87,
            ),
          ),
          // Adding the drawer items back properly
          ListTile(
            leading: const Icon(
              Icons.ac_unit,
              color: Colors.white,
              size: 20,
            ),
            title: const Text(
              "1 Acclimatization",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Product Sans Regular",
                fontSize: 13,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, "/addAcclimatization"),
          ),
          ListTile(
            leading: const Icon(Icons.ac_unit_outlined, color: Colors.white),
            title: const Text(
              "2 Acclimatization",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Product Sans Regular",
                fontSize: 13,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, "/secondAcclimatization"),
          ),
          ListTile(
            leading: const Icon(Icons.eco, color: Colors.white),
            title: const Text(
              "1st Cut Records",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Product Sans Regular",
                fontSize: 13,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, "/firstCut"),
          ),
          ListTile(
            leading: const Icon(Icons.eco, color: Colors.white),
            title: const Text(
              "2nd Cut Records",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Product Sans Regular",
                fontSize: 13,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, "/secondCut"),
          ),
          // ListTile(
          //   leading: const Icon(Icons.eco, color: Colors.white),
          //   title: const Text(
          //     "Greenhouse",
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontFamily: "Product Sans Regular",
          //       fontSize: 13,
          //     ),
          //   ),
          //   onTap: () => Navigator.pushNamed(context, "/greenHouse"),
          // ),
          ListTile(
            leading: const Icon(Icons.grass, color: Colors.white),
            title: const Text(
              "1st Reproduction",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Product Sans Regular",
                fontSize: 13,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, "/firstReproduction"),
          ),
          ListTile(
            leading: const Icon(Icons.grass_outlined, color: Colors.white),
            title: const Text(
              "2nd Reproduction",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Product Sans Regular",
                fontSize: 13,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, "/secondReproduction"),
          ),
          ListTile(
            leading: const Icon(Icons.grass_outlined, color: Colors.white),
            title: const Text(
              "1st Field Details",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Product Sans Regular",
                fontSize: 13,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, "/fieldDetails"),
          ),
          ListTile(
            leading: const Icon(Icons.grass_outlined, color: Colors.white),
            title: const Text(
              "2nd Field Details",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Product Sans Regular",
                fontSize: 13,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, "/secfieldDetails"),
          ),
          ListTile(
            leading: const Icon(Icons.forest, color: Colors.white),
            title: const Text(
              "Production",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Product Sans Regular",
                fontSize: 13,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, "/production"),
          ),
          const Divider(color: Colors.white),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text(
              "Settings",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Product Sans Regular",
                fontSize: 13,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, "/settings"),
          ),
          ListTile(
            leading: const Icon(Icons.help, color: Colors.white),
            title: const Text(
              "Help/Guide",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Product Sans Regular",
                fontSize: 13,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, "/help"),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text(
              "Log out",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Product Sans Regular",
                fontSize: 13,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, "/logout"),
          ),
        ],
      ),
    );
  }
}
