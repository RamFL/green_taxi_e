import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_taxi_e/controller/auth_controller.dart';
import 'package:green_taxi_e/views/add_payment_card_screen.dart';
import 'package:green_taxi_e/widgets/green_intro_widget.dart';

import '../utils/app_colors.dart';

class MyCardScreen extends StatefulWidget {
  const MyCardScreen({Key? key}) : super(key: key);

  @override
  State<MyCardScreen> createState() => _MyCardScreenState();
}

class _MyCardScreenState extends State<MyCardScreen> {
  String cardNumber = '5555 55555 5555 4444';
  String expiryDate = '12/25';
  String cardHolderName = 'Osama Qureshi';
  String cvvCode = '123';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;

  AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    authController.getUserCards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Stack(
          children: [
            greenIntroWidgetWithoutLogos(title: 'My Card'),
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              bottom: 80,
              child: Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (ctx, i) {

                    String cardNumber = '';
                    String cardHolderName = '';
                    String expiryDate = '';
                    String cvv = '';

                    try {
                      cardNumber = authController.userCards.value[i].get('Card Number');
                    }catch (e) {
                      cardNumber = '';
                    }

                    try {
                      cardHolderName = authController.userCards.value[i].get('Card Holder Name');
                    }catch (e) {
                      cardHolderName = '';
                    }

                    try {
                      expiryDate = authController.userCards.value[i].get('Expiry Date');
                    }catch (e) {
                      expiryDate = '';
                    }

                    try {
                      cvv = authController.userCards.value[i].get('Cvv');
                    }catch (e) {
                      cvv = '';
                    }

                    return CreditCardWidget(
                      cardBgColor: Colors.black,
                      cardNumber: cardNumber,
                      expiryDate: expiryDate,
                      cardHolderName: cardHolderName,
                      cvvCode: cvv,
                      bankName: '',
                      showBackView: isCvvFocused,
                      obscureCardNumber: true,
                      obscureCardCvv: true,
                      isHolderNameVisible: true,
                      isSwipeGestureEnabled: true,
                      onCreditCardWidgetChange:
                          (CreditCardBrand creditCardBrand) {},
                    );
                  },
                  itemCount: authController.userCards.length,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Add new card",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.greenColor),
                  ),
                  const SizedBox(width: 10),
                  FloatingActionButton(
                    onPressed: () {
                      Get.to(() => const AddPaymentCardScreen());
                    },
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    backgroundColor: AppColors.greenColor,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
