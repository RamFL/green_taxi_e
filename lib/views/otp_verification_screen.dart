import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/green_intro_widget.dart';
import '../widgets/otp_verification_widget.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String? phoneNumber;

  const OtpVerificationScreen({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();

    print("getting Ph No:- ${widget.phoneNumber}");
    authController.phoneAuth(widget.phoneNumber!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                greenIntroWidget(),
                Positioned(
                  top: Get.height * 0.08,
                  left: Get.width * 0.02,
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.greenColor,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            otpVerificationWidget(),
          ],
        ),
      ),
    );
  }
}
