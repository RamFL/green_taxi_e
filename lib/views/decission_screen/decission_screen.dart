import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_taxi_e/controller/auth_controller.dart';
import 'package:green_taxi_e/views/login_screen.dart';

import '../../widgets/decision_button.dart';
import '../../widgets/green_intro_widget.dart';
import '../driver/car_registration/car_registration_templates.dart';

class DecisionScreen extends StatelessWidget {
  DecisionScreen({Key? key}) : super(key: key);

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            greenIntroWidget(),
            const SizedBox(height: 30),
            Text(
              'Welcome!',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 40),
            decisionButton(
              'assets/driver.png',
              'Login as Driver',
              () {
                authController.isLoginAsDriver = true;
                Get.to(() => const LoginScreen());
              },
              Get.width * 0.8,
            ),
            const SizedBox(height: 22),
            decisionButton(
              'assets/customer.png',
              'Login as User',
              () {
                authController.isLoginAsDriver = false;
                Get.to(() => const LoginScreen());
              },
              Get.width * 0.8,
            ),
          ],
        ),
      ),
    );
  }
}
