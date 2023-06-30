import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_taxi_e/controller/auth_controller.dart';
import 'package:green_taxi_e/utils/app_colors.dart';
import 'package:green_taxi_e/views/driver/car_registration/pages/document_uploaded_page.dart';
import 'package:green_taxi_e/views/driver/car_registration/pages/location_page.dart';
import 'package:green_taxi_e/views/driver/car_registration/pages/upload_document_page.dart';
import 'package:green_taxi_e/views/driver/car_registration/pages/vachile_type_page.dart';
import 'package:green_taxi_e/views/driver/car_registration/pages/vehicle_color_page.dart';
import 'package:green_taxi_e/views/driver/car_registration/pages/vehicle_company_page.dart';
import 'package:green_taxi_e/views/driver/car_registration/pages/vehicle_model_page.dart';
import 'package:green_taxi_e/views/driver/car_registration/pages/vehicle_model_year_page.dart';
import 'package:green_taxi_e/views/driver/car_registration/pages/vehicle_number_page.dart';
import 'package:green_taxi_e/views/driver/car_registration/verification_pending_page.dart';

import '../../../widgets/green_intro_widget.dart';

class CarRegistrationTemplates extends StatefulWidget {
  const CarRegistrationTemplates({Key? key}) : super(key: key);

  @override
  State<CarRegistrationTemplates> createState() =>
      _CarRegistrationTemplatesState();
}

class _CarRegistrationTemplatesState extends State<CarRegistrationTemplates> {
  String selectedLocation = '';
  String selectedVehicleType = '';
  String selectedVehicleCompany = '';
  String selectedVehicleModel = '';
  String selectedModelYear = '';
  TextEditingController vehicleNumberController = TextEditingController();
  String vehicleColor = '';
  File? document;

  PageController pageController = PageController();

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          greenIntroWidgetWithoutLogos(
              title: 'Car Registration',
              subtitle: 'Complete the process detail'),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PageView(
                onPageChanged: (int page) {
                  currentPage = page;
                },
                controller: pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  LocationPage(
                    selectedLocation: selectedLocation,
                    onSelect: (String location) {
                      setState(() {
                        selectedLocation = location;
                      });
                    },
                  ),
                  VehicleTypePage(
                    selectedCarType: selectedVehicleType,
                    onSelected: (String type) {
                      setState(() {
                        selectedVehicleType = type;
                      });
                    },
                  ),
                  VehicleCompanyPage(
                    selectedCompany: selectedVehicleCompany,
                    onSelected: (String company) {
                      setState(() {
                        selectedVehicleCompany = company;
                      });
                    },
                  ),
                  VehicleModelPage(
                    selectedModel: selectedVehicleModel,
                    onSelected: (String model) {
                      setState(() {
                        selectedVehicleModel = model;
                      });
                    },
                  ),
                  VehicleModelYearPage(
                    onSelected: (int year) {
                      setState(() {
                        selectedModelYear = year.toString();
                      });
                    },
                  ),
                  VehicleNumberPage(
                    controller: vehicleNumberController,
                  ),
                  VehicleColorPage(
                    onSelectedColor: (String color) {
                      vehicleColor = color;
                    },
                  ),
                  UploadDocumentPage(
                    onSelectedImage: (File doc) {
                      document = doc;
                    },
                  ),
                  DocumentUploadedPage(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentPage < 8) {
            pageController.animateToPage(currentPage + 1,
                duration: const Duration(seconds: 1), curve: Curves.easeIn);
          } else {
            uploadDriverCarEntry();
          }
        },
        child: Obx(
          () => isUploading.value
              ? Icon(
                  Icons.file_upload,
                  color: Colors.white,
                )
              : Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
        ),
        backgroundColor: AppColors.greenColor,
      ),
    );
  }

  var isUploading = false.obs;

  void uploadDriverCarEntry() async {
    isUploading(true);

    String imageUrl = await Get.find<AuthController>().uploadImage(document!);

    Map<String, dynamic> carData = {
      'country': selectedLocation,
      'vehicle_type': selectedVehicleType,
      'vehicle_company': selectedVehicleCompany,
      'vehicle_model': selectedVehicleModel,
      'vehicle_year': selectedModelYear,
      'vehicle_number': vehicleNumberController.text.trim(),
      'vehicle_color': vehicleColor,
      'vehicle_document': imageUrl,
    };

    await Get.find<AuthController>().uploadCarEntry(carData);
    isUploading(false);
    Get.off(() => const VerificationPendingPage());
  }
}
