import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:myapp/utils/constants.dart';

// Define a provider to manage the state of the checkboxes
final reportTypeProvider = StateProvider<Map<String, bool>>((ref) {
  return {
    'Diseases': false,
    'Pest': false,
  };
});

class ReportPage extends ConsumerStatefulWidget {
  const ReportPage({super.key});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  File? _image;
  @override
  Widget build(BuildContext context) {
    final reportType = ref.watch(reportTypeProvider);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Report Page',
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Report Diseases/Pest Text
              Text(
                "Report Diseases/Pest",
                style: AppConstants.titleTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(10),
              // Text saying what are you reporting about
              Text(
                "What are you reporting about?",
                style: AppConstants.subtitleTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const Gap(10),
              // Row with two Texts
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Text saying Diseases
                  Row(
                    children: [
                      Text(
                        "Diseases",
                        style: AppConstants.subtitleTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      // a check box here
                      Checkbox(
                        value: reportType['Diseases'],
                        onChanged: (bool? value) {
                          ref.read(reportTypeProvider.notifier).update((state) {
                            return {
                              ...state,
                              'Diseases': value ?? false,
                            };
                          });
                        },
                      ),
                    ],
                  ),
                  // Text saying Pest
                  Row(
                    children: [
                      Text(
                        "Pest",
                        style: AppConstants.subtitleTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Checkbox(
                        value: reportType['Pest'],
                        onChanged: (bool? value) {
                          ref.read(reportTypeProvider.notifier).update((state) {
                            return {
                              ...state,
                              'Pest': value ?? false,
                            };
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(10),
              // Add more widgets as need
              const MyReportContainer(
                ),
            ],
          ),
        ),
      ),
    );
  }

  // a custoner cointainer widget  that has a row of icons with text and a button


}
class MyReportContainer extends StatelessWidget {
  const MyReportContainer({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: AppConstants.primaryColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Icon(Icons.upload, color:Colors.white, size: 30),
                  Text(
                    "Upload an Image",
                    style: AppConstants.subtitleTextStyle.copyWith(
                      color:Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Icon(Icons.analytics, color:Colors.white, size: 30),
                  Text(
                    "See a dianogsis",
                    style: AppConstants.subtitleTextStyle.copyWith(
                      color:Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Icon(Icons.medical_services, color:Colors.white, size: 30),
                  Text(
                    "Get Medecine",
                    style: AppConstants.subtitleTextStyle.copyWith(
                      color:Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Gap(5),
          const Gap(10),
          ElevatedButton(
            onPressed: (){

            },
            style: ElevatedButton.styleFrom(
              backgroundColor:const Color(0xFF00FF0A).withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child:  Text('Upload an Image', style: AppConstants.subtitleTextStyle.copyWith(
              color: Colors.white
            ),),
          ),

          // a text to say  "or pick an image "

        ],
      ),
    );
  }
}
