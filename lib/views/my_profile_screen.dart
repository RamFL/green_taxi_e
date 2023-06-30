import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import 'package:image_picker/image_picker.dart';
import '../controller/auth_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/green_intro_widget.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController homeController = TextEditingController();
  TextEditingController businessController = TextEditingController();
  TextEditingController shopController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AuthController authController = Get.find<AuthController>();
  //

  //
  LatLng? homeAddress;
  LatLng? businessAddress;
  LatLng? shoppingAddress;

  /// To pick image from gallery or camera
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    nameController.text = authController.myUser.value.name ?? "";
    homeController.text = authController.myUser.value.hAddress ?? "";
    businessController.text = authController.myUser.value.bAddress ?? "";
    shopController.text = authController.myUser.value.mallAddress ?? "";
    homeAddress = authController.myUser.value.homeAddress!;
    businessAddress = authController.myUser.value.businessAddress!;
    shoppingAddress = authController.myUser.value.shoppingAddress!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: Get.height * 0.4,
              child: Stack(
                children: [
                  greenIntroWidgetWithoutLogos(title: 'My Profile'),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        getImage(ImageSource.camera);
                      },
                      child: selectedImage == null
                          ? authController.myUser.value.image != null
                              ? Container(
                                  width: 120,
                                  height: 120,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xffD6D6D6),
                                    border: Border.all(
                                        color: Colors.white, width: 3),
                                    image: DecorationImage(
                                      image: NetworkImage(authController
                                          .myUser.value.image
                                          .toString()),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 120,
                                  height: 120,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffD6D6D6),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                          : Container(
                              width: 120,
                              height: 120,
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xffD6D6D6),
                                border:
                                    Border.all(color: Colors.white, width: 3),
                                image: DecorationImage(
                                  image: FileImage(selectedImage!),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    textFieldWidget(
                        'Name', Icons.person_outlined, nameController,
                        (String? input) {
                      if (input!.isEmpty) {
                        return "Name is required!";
                      } else if (input.length < 5) {
                        return "Please enter a valid Name !";
                      } else {
                        return null;
                      }
                    }, onTap: () {}, readable: false),
                    const SizedBox(height: 10),
                    textFieldWidget(
                      'Home Address',
                      Icons.home_outlined,
                      homeController,
                      (String? input) {
                        if (input!.isEmpty) {
                          return "Home address is required";
                        } else {
                          return null;
                        }
                      },
                      onTap: () async {
                        Prediction? p = await authController
                            .showGoogleAutoComplete(context);

                        String selectedAddress = p!.description!;
                        homeController.text = selectedAddress;

                        ///now let's translate this selected address and convert it to LatLng Obj.
                        homeAddress = await authController
                            .buildLatLngFromAddress(selectedAddress);

                        /// store this information into firebase together once update is clicked
                      },
                      readable: true,
                    ),
                    const SizedBox(height: 10),
                    textFieldWidget(
                      'Business Address',
                      Icons.card_travel,
                      businessController,
                      (String? input) {
                        if (input!.isEmpty) {
                          return "Business address is required";
                        } else {
                          return null;
                        }
                      },
                      onTap: () async {
                        Prediction? p = await authController
                            .showGoogleAutoComplete(context);

                        String selectedAddress = p!.description!;
                        businessController.text = selectedAddress;

                        ///now let's translate this selected address and convert it to LatLng Obj.
                        businessAddress = await authController
                            .buildLatLngFromAddress(selectedAddress);

                        /// store this information into firebase together once update is clicked
                      },
                      readable: true,
                    ),
                    const SizedBox(height: 10),
                    textFieldWidget(
                      'Shopping Center',
                      Icons.shopping_cart_outlined,
                      shopController,
                      (String? input) {
                        if (input!.isEmpty) {
                          return "Shopping Center address is required";
                        } else {
                          return null;
                        }
                      },
                      onTap: () async {
                        Prediction? p = await authController
                            .showGoogleAutoComplete(context);

                        String selectedAddress = p!.description!;
                        shopController.text = selectedAddress;

                        ///now let's translate this selected address and convert it to LatLng Obj.
                        shoppingAddress = await authController
                            .buildLatLngFromAddress(selectedAddress);

                        /// store this information into firebase together once update is clicked
                      },
                      readable: true,
                    ),
                    const SizedBox(height: 30),
                    Obx(
                      () => authController.isProfileUploading.value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : greenButton('Update', () {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }

                              authController.isProfileUploading(true);
                              authController.storeUserInfo(
                                selectedImage,
                                nameController.text,
                                homeController.text,
                                businessController.text,
                                shopController.text,
                                url: authController.myUser.value.image ?? "",
                                homeLatLng: homeAddress!,
                                businessLatLng: businessAddress!,
                                shoppingLatLng: shoppingAddress!,
                              );
                            }),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget textFieldWidget(String title, IconData iconData,
      TextEditingController controller, Function validator,
      {Function? onTap, bool readable = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xffA7A7A7)),
        ),
        const SizedBox(
          height: 6,
        ),
        Container(
          width: Get.width,
          // height: 50,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 1,
                )
              ],
              borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            onTap: () => onTap!(),
            readOnly: readable,
            validator: (input) => validator(input),
            controller: controller,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xffA9B9A9),
            ),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(
                  iconData,
                  color: AppColors.greenColor,
                ),
              ),
              border: InputBorder.none,
            ),
          ),
        )
      ],
    );
  }

  Widget greenButton(String title, Function onPressed) {
    return MaterialButton(
      minWidth: Get.width,
      height: 50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      color: AppColors.greenColor,
      onPressed: () => onPressed!(),
      child: Text(
        title,
        style: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
