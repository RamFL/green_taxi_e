import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_taxi_e/widgets/text_widget.dart';

import '../utils/app_constants.dart';
import '../views/otp_verification_screen.dart';

// CountryService countryService = CountryService();
Widget loginWidget() {
  // Country country = Country.worldWide;

  String? countryCode;

  onSubmit(String? input) {
    Get.to(() => OtpVerificationScreen(phoneNumber: countryCode! + input!));
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(text: AppConstants.helloNiceToMeetYou),
        textWidget(
            text: AppConstants.getMovingWithGreenTaxi,
            fontSize: 22,
            fontWeight: FontWeight.bold),
         const SizedBox(height: 40),
        Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 3,
                blurRadius: 3,
              ),
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: CountryCodePicker(
                    onChanged: (CountryCode? CC) {
                      countryCode = CC!.dialCode;
                      print(countryCode);
                    },
                    initialSelection: 'IN',
                    favorite: ['+91', 'IN'],
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    showFlagMain: true,
                    showDropDownButton: true,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 55,
                color: Colors.black.withOpacity(0.2),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    onSubmitted: (String? input) => onSubmit(input),
                    decoration: InputDecoration(
                      hintText: AppConstants.enterMobileNumber,
                      hintStyle: GoogleFonts.poppins(fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                    text: "${AppConstants.byCreating} ",
                  ),
                  TextSpan(
                    text: "${AppConstants.termsOfService} ",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text: "and ",
                  ),
                  TextSpan(
                    text: "${AppConstants.privacyPolicy} ",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ]),
          ),
        ),
      ],
    ),
  );
}
