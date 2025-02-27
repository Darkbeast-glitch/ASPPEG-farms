import 'package:flutter/material.dart';
import 'package:myapp/utils/constants.dart';

class MyContainer extends StatelessWidget {
  const MyContainer({super.key, required this.varityName, required this.totalQuantity});

  final String  varityName;
  final String totalQuantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF242729),
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
                "Variety : ",
                style: AppConstants.titleTextStyle.copyWith(
                  fontSize: 11,
                  color: const Color(0xFF05E01B),
                ),
              )
              // Variety name value
              ,
              Text(
               varityName,
                style: AppConstants.titleTextStyle.copyWith(
                  fontSize: 11,
                  color: const Color(0xFF05E01B),
                ),
              ),
            ],
          ),
          // Row with Total Quanity and the  price
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Total Qunantity text
              const Text(
                "Total Quantity:",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // total quantity value
               Text(
               totalQuantity,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
