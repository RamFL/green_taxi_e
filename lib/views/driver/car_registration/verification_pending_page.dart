import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_taxi_e/views/driver/driver_home_screen.dart';
import 'package:green_taxi_e/widgets/green_intro_widget.dart';

class VerificationPendingPage extends StatefulWidget {
  const VerificationPendingPage({Key? key}) : super(key: key);

  @override
  State<VerificationPendingPage> createState() =>
      _VerificationPendingPageState();
}

class _VerificationPendingPageState extends State<VerificationPendingPage> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Get.offAll(() => const DriverHomeScreen());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          greenIntroWidgetWithoutLogos(
            title: 'Verification!',
            subtitle: 'Process status',
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Verification Pending',
                  style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                const SizedBox(height: 20),
                Text(
                  'Your document is still pending for verification. Once it’s all verified you start getting rides. please sit tight',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff7D7D7D),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
