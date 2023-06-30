import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/green_intro_widget.dart';
import '../widgets/login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // final countryPicker = const  FlCountryCodePicker();
  //
  // CountryCode countryCode = CountryCode(name: 'India', code: 'IND', dialCode: '+91');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              greenIntroWidget(),
              const SizedBox(height: 40),
              loginWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
