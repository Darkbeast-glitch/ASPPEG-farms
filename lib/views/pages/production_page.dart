import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/my_prod_box.dart';

class ProductionPage extends StatelessWidget {
  const ProductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> productionName = [
      {
        "varietyName": "Bellvue",
        "totalQuantity": "1000",
      },
      {
        "varietyName": "Murasaki",
        "totalQuantity": "2000",
      },
      {
        "varietyName": "Bellvue",
        "totalQuantity": "3000",
      },
      {
        "varietyName": "Bellvue",
        "totalQuantity": "1000",
      },
    ];

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Production',
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
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Count Summary text
              Text(
                "Count Summary",
                style: AppConstants.titleTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Iterate over the productionName list and create a MyContainer for each item
              Expanded(
                child: ListView.builder(
                  itemCount: productionName.length, // Set the itemCount
                  itemBuilder: (context, index) {
                    final item = productionName[index];
                    return Column(
                      children: [
                        MyContainer(
                          varityName: item['varietyName'],
                          totalQuantity: item['totalQuantity'],
                        ),
                        const SizedBox(height: 30),
                        // Add spacing between containers
                      ],
                    );
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "All Total Display",
                    style: AppConstants.titleTextStyle.copyWith(
                      fontSize: 11,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const Gap(10),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF4A315E),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    //  Variety name text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Variety name text

                        Text(
                          "Grand Total",
                          style: AppConstants.titleTextStyle.copyWith(
                            fontSize: 11,
                            color: const Color(0xFF05E01B),
                          ),
                        )
                        // Variety name value
                      ],
                    ),
                    // Row with Total Quanity and the  price
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Total Qunantity text
                        Text(
                          "Total Quantity:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // total quantity value
                        Text(
                          "25000",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 40,
        height: 40,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
          backgroundColor: Colors.white,
          child: const Icon(Icons.home, size: 30),
        ),
      ),
    );
  }
}
