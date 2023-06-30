import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_taxi_e/widgets/pinput_widget.dart';
import 'package:green_taxi_e/widgets/text_widget.dart';

import '../utils/app_constants.dart';

Widget otpVerificationWidget() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(text: AppConstants.phoneVerification),
        textWidget(
            text: AppConstants.enterOtp,
            fontSize: 22,
            fontWeight: FontWeight.bold),
        const SizedBox(height: 40),
        Container(
          width: double.infinity,
          height: 50,
          child: RoundedWithShadow(),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.poppins(color: Colors.black, fontSize: 13),
              children: [
                const TextSpan(
                  text: "${AppConstants.resendCode} ",
                ),
                TextSpan(
                  text: "10 Sec. ",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
