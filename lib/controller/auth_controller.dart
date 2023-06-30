import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:green_taxi_e/models/user_model/user_model.dart';
import 'package:green_taxi_e/utils/app_constants.dart';
import 'package:green_taxi_e/views/driver/car_registration/car_registration_templates.dart';
import 'package:green_taxi_e/views/driver/driver_profile_setup.dart';
import 'package:path/path.dart' as Path;

import '../views/driver/driver_home_screen.dart';
import '../views/home_screen.dart';
import '../views/profile_setting_screen.dart';

class AuthController extends GetxController {
  String userUid = "";
  var verId = '';
  int? resendTokenId;
  bool phoneAuthCheck = false;
  dynamic credentials;
  RxBool isProfileUploading = false.obs;

  bool isLoginAsDriver = false;

  // For phone authentication
  phoneAuth(String phone) async {
    log("Phone Auth Called");
    try {
      credentials = null;
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          log('Completed');
          credentials = credential;
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        forceResendingToken: resendTokenId,
        verificationFailed: (FirebaseAuthException e) {
          log('Failed');
          if (e.code == 'invalid-phone-number') {
            debugPrint('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          log('Code sent');
          verId = verificationId;
          resendTokenId = resendToken;
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      log("Error occured $e");
    }
  }

  // To verify the  OTP
  verifyOtp(String otpNumber) async {
    log("verify OTP Called");
    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: otpNumber);

    log("you are LoggedIn");

    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      decideRoute();
    });
  }

  decideRoute() {
    ///Step 1 - Check user login?
    User? user = FirebaseAuth.instance.currentUser;

    if (isLoginAsDriver && user != null) {
      /// step 2 - Check weather driver profile exists?

      FirebaseFirestore.instance
          .collection('Drivers')
          .doc(user.uid)
          .get()
          .then((value) {
        if (value.exists) {
          Get.offAll(() => const DriverHomeScreen());
        } else {
          Get.offAll(() => const DriverProfileSetup());
        }
      }).catchError((e) {
        print("Error while decide route $e");
      });
    } else if (user != null) {
      ///step 2 - Check weather user profile exists?
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((value) {
        if (value.exists) {
          Get.offAll(() => HomeScreen());
        } else {
          Get.offAll(() => const ProfileSettingScreen());
        }
      }).catchError((e) {
        print("Error while decide route $e");
      });
    }
  }

  /// To upload selected image to Firebase storage
  uploadImage(File image) async {
    String imageUrl = '';
    String fileName = Path.basename(image.path);

    var reference = FirebaseStorage.instance.ref().child('users/$fileName');
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    await taskSnapshot.ref.getDownloadURL().then((value) {
      imageUrl = value;
      print('Downloaded URL: $value');
    });
    return imageUrl;
  }

  /// To store data into firebase database
  storeUserInfo(
    File? selectedImage,
    String name,
    String home,
    String business,
    String shopping, {
    String url = '',
    LatLng? homeLatLng,
    LatLng? businessLatLng,
    LatLng? shoppingLatLng,
  }) async {
    String new_url = url;

    if (selectedImage != null) {
      new_url = await uploadImage(selectedImage);
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'profileImage': new_url,
      'name': name,
      'home_address': home,
      'business_address': business,
      'shopping_address': shopping,
      'home_latlng': GeoPoint(homeLatLng!.latitude, homeLatLng.longitude),
      'business_latlng':
          GeoPoint(businessLatLng!.latitude, businessLatLng.longitude),
      'shopping_latlng':
          GeoPoint(shoppingLatLng!.latitude, shoppingLatLng.longitude),
    }, SetOptions(merge: true)).then((value) {
      isProfileUploading(false);
      Get.to(() => HomeScreen());
    });
  }

  ///To get user information from firebase

  Rx<UserModel> myUser = UserModel().obs;

  getUserInfo() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((userData) {
      myUser.value = UserModel.fromJson(userData.data()!);
    });
  }

  ///Store user Payment Card information
  storeUserCard(
      String cardNumber, String expiry, String cvv, String name) async {
    userUid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('cards')
        .add({
      'Card Holder Name': name,
      'Card Number': cardNumber,
      'Expiry Date': expiry,
      'Cvv': cvv,
    });
  }

  /// Fetch user cards and its details
  RxList userCards = [].obs;

  getUserCards() async {
    userUid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('cards')
        .get()
        .then((cardDetails) {
      userCards.value = cardDetails.docs;
    });
  }

  /// For location search autocomplete
  Future<Prediction?> showGoogleAutoComplete(BuildContext context) async {
    Prediction? p = await PlacesAutocomplete.show(
      offset: 0,
      radius: 1000,
      strictbounds: false,
      region: "in",
      language: "en",
      context: context,
      mode: Mode.overlay, // Mode.fullscreen
      apiKey: AppConstants.kGoogleApiKey,
      types: [],
      components: [Component(Component.country, "in")],
      hint: "Search location",
    );

    return p;
  }

  ///To get the Lat Lng from any given address
  Future<LatLng> buildLatLngFromAddress(String place) async {
    List<geocoding.Location> locations =
        await geocoding.locationFromAddress(place);

    return LatLng(locations.first.latitude, locations.first.longitude);
  }

  /// To store driver profile
  storeDriverProfile(File? selectedImage, String name, String email,
      {String url = ''}) async {
    String url_new = url;

    if (selectedImage != null) {
      url_new = await uploadImage(selectedImage);
    }

    String uid = FirebaseAuth.instance.currentUser!.uid;
    String driverPhoneNum = FirebaseAuth.instance.currentUser!.phoneNumber!;

    await FirebaseFirestore.instance.collection('Drivers').doc(uid).set({
      'profile_image': url_new,
      'name': name,
      'Email': email,
      'isDriver': true,
      'Phone number': driverPhoneNum,
    }, SetOptions(merge: true)).then((value) {
      isProfileUploading(false);

      Get.off(() => const CarRegistrationTemplates());
    });
  }

  ///To update car information
  Future<bool> uploadCarEntry(Map<String, dynamic> carData) async {
    bool isUploaded = false;

    String uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('Drivers')
        .doc(uid)
        .set(carData, SetOptions(merge: true));

    isUploaded = true;

    print("Car registration complete");

    return isUploaded;
  }
}
