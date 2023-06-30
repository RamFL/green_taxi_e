import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_taxi_e/widgets/green_intro_widget.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          greenIntroWidgetWithoutLogos(
            title: 'Welcome',
          ),
          const SizedBox(height: 30),
          Container(
            width: Get.width * 0.8,
            height: 100,
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xff2FB654).withOpacity(0.26), width: 1),
            ),
            child: Text(
              'Driver Module coming soon, Be ready to join as a driver and earn money',
              style: GoogleFonts.paytoneOne(
                color: Colors.black87,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
