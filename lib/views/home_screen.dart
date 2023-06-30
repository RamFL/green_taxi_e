import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:green_taxi_e/controller/polyline_handler.dart';
import 'package:green_taxi_e/views/my_card_screen.dart';

import '../controller/auth_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/text_widget.dart';
import 'my_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? mapController;
  String? mapStyle;
  AuthController authController = Get.find<AuthController>();

  late LatLng destination;
  late LatLng source;

  // final Set<Polyline> _polyline = {};
  Set<Marker> markers = Set<Marker>();
  List<String> list = <String>[
    '**** **** **** 8789',
    '**** **** **** 8921',
    '**** **** **** 1233',
    '**** **** **** 4352'
  ];
  String dropdownValue = '**** **** **** 8789';



  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(22.6659, 88.4110),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    authController.getUserInfo();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      mapStyle = string;
    });

    loadCustomMarker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: GoogleMap(
              markers: markers,
              polylines: polyline,
              zoomControlsEnabled: false,
              // mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;

                mapController!.setMapStyle(mapStyle);
              },
            ),
          ),
          buildProfileTile(),
          buildTextField(),
          showSourceField ? buildTextFieldForSource() : Container(),
          buildCurrentLocationIcon(),
          buildNotificationIcon(),
          buildBottomSheet(),
        ],
      ),
    );
  }

  Widget buildProfileTile() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        width: Get.width,
        height: Get.width * 0.5,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(color: Colors.white70),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => authController.myUser.value.image == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      height: 65,
                      width: 65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                              authController.myUser.value.image.toString()),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Good morning, ',
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontSize: 14),
                        ),
                        TextSpan(
                          text: authController.myUser.value.name == null
                              ? 'Mark'
                              : authController.myUser.value.name
                                  .toString()
                                  .trim(),
                          style: GoogleFonts.poppins(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  'Where are you going ?',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  TextEditingController destinationController = TextEditingController();
  TextEditingController sourceController = TextEditingController();

  bool showSourceField = false;

  Widget buildTextField() {
    return Positioned(
      top: 163,
      left: 20,
      right: 20,
      child: Container(
        width: Get.width,
        height: 50,
        padding: const EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 4,
                blurRadius: 10,
              )
            ],
            borderRadius: BorderRadius.circular(8)),
        child: TextFormField(
          readOnly: true,
          controller: destinationController,
          onTap: () async {
            Prediction? p = await authController.showGoogleAutoComplete(context);

            String selectedPlace = p!.description!;
            destinationController.text = selectedPlace;

            /// To Location from address, basically Lat Lng of any location
            // List<geocoding.Location> locations =
            //     await geocoding.locationFromAddress(selectedPlace);

            /// Get the actual lat and lng of location and store in destination
            // destination =
            //     LatLng(locations.first.latitude, locations.first.longitude);

            destination = await authController.buildLatLngFromAddress(selectedPlace);

            /// Add a marker on location
            markers.add(Marker(
                markerId: MarkerId(selectedPlace),
                infoWindow: InfoWindow(title: 'Destination: $selectedPlace'),
                position: destination,
                icon: BitmapDescriptor.fromBytes(markIcons)));

            /// To animate the camera to new selected location
            mapController!.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: destination, zoom: 15),
              ),
            );

            setState(() {
              showSourceField = true;
            });
          },
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xffA9B9A9),
          ),
          decoration: InputDecoration(
            hintText: 'Search for a destination',
            hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            suffixIcon: const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(
                Icons.search,
              ),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget buildTextFieldForSource() {
    return Positioned(
      top: 220,
      left: 20,
      right: 20,
      child: Container(
        width: Get.width,
        height: 50,
        padding: const EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 4,
                blurRadius: 10,
              )
            ],
            borderRadius: BorderRadius.circular(8)),
        child: TextFormField(
          controller: sourceController,
          readOnly: true,
          onTap: () async {
            buildSourceSheet();
          },
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xffA9B9A9),
          ),
          decoration: InputDecoration(
            hintText: 'From:',
            hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(
                Icons.search,
              ),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget buildCurrentLocationIcon() {
    return const Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.only(bottom: 30, right: 8),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.green,
          child: Icon(
            Icons.my_location,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildNotificationIcon() {
    return const Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: 30, left: 8),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.notifications,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget buildBottomSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: Get.width * 0.8,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              spreadRadius: 4,
              blurRadius: 10,
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Center(
          child: Container(
            width: Get.width * 0.6,
            height: 4,
            color: Colors.black45,
          ),
        ),
      ),
    );
  }

  buildDrawerItem(
      {required String title,
      required Function onPressed,
      Color color = Colors.black,
      double fontSize = 20,
      FontWeight fontWeight = FontWeight.w700,
      double height = 45,
      bool isVisible = false}) {
    return SizedBox(
      height: height,
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        // minVerticalPadding: 0,
        dense: true,
        onTap: () => onPressed(),
        title: Row(
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: fontSize, fontWeight: fontWeight, color: color),
            ),
            const SizedBox(
              width: 5,
            ),
            isVisible
                ? CircleAvatar(
                    backgroundColor: AppColors.greenColor,
                    radius: 15,
                    child: Text(
                      '1',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Get.to(() => const MyProfileScreen());
            },
            child: SizedBox(
              height: 200,
              child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: AppColors.greenColor,
                  ),
                  child: Obx(
                    () => Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        authController.myUser.value.image == null
                            ? Container(
                                width: 80,
                                height: 80,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage('assets/person.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              )
                            : Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(authController
                                        .myUser.value.image
                                        .toString()),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Good Morning, ',
                                  style: GoogleFonts.poppins(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 16)),
                              Text(
                                authController.myUser.value.name == null
                                    ? "Name.."
                                    : authController.myUser.value.name
                                        .toString(),
                                style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                buildDrawerItem(title: 'Payment History', onPressed: () {}),
                buildDrawerItem(title: 'My Credit Cards', onPressed: () {
                  Get.to(() => const MyCardScreen());
                }),
                buildDrawerItem(
                    title: 'Ride History', onPressed: () {}, isVisible: true),
                buildDrawerItem(title: 'Invite Friends', onPressed: () {}),
                buildDrawerItem(title: 'Promo Codes', onPressed: () {}),
                buildDrawerItem(title: 'Settings', onPressed: () {}),
                buildDrawerItem(title: 'Support', onPressed: () {}),
                buildDrawerItem(
                    title: 'Log Out',
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    }),
              ],
            ),
          ),
          Spacer(),
          Divider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              children: [
                buildDrawerItem(
                    title: 'Do more',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.35),
                    height: 20),
                const SizedBox(
                  height: 20,
                ),
                buildDrawerItem(
                    title: 'Get food delivery',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.35),
                    height: 20),
                buildDrawerItem(
                    title: 'Make money driving',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.35),
                    height: 20),
                buildDrawerItem(
                  title: 'Rate us on store',
                  onPressed: () {},
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.35),
                  height: 20,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  late Uint8List markIcons;

  loadCustomMarker() async {
    markIcons = await loadAsset('assets/dest_marker.png', 100);
  }

  Future<Uint8List> loadAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    FrameInfo fi = await codec.getNextFrame();

    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  // void drawPolyline(String placeId) {
  //   polyline.clear();
  //   polyline.add(Polyline(
  //     polylineId: PolylineId(placeId),
  //     visible: true,
  //     points: [source, destination],
  //     color: AppColors.greenColor,
  //     width: 3,
  //   ));
  // }

  void buildSourceSheet() {
    Get.bottomSheet(
      Container(
        width: Get.width,
        height: Get.height * 0.5,
        padding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Select your location",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Home Address",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () async {
                source = authController.myUser.value.homeAddress!;
                sourceController.text = authController.myUser.value.hAddress!;


                if(markers.length >= 2) {
                  markers.remove(markers.last);
                }

                /// Add a marker on location
                markers.add(Marker(
                    markerId: MarkerId(authController.myUser.value.hAddress!),
                    infoWindow: InfoWindow(title: 'Source: ${authController.myUser.value.hAddress!}'),
                    position: source,
                    ));

                /// To draw polyline between two points in map
                // drawPolyline(authController.myUser.value.hAddress!);
                await getPolylines(source, destination);

                /// To animate the camera to new selected location
                mapController!.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(target: source, zoom: 15),
                  ),
                );

                setState(() {});

                Get.back();

                buildRideConfirmationSheet();
              },
              child: Container(
                width: Get.width,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          spreadRadius: 4,
                          blurRadius: 10)
                    ]),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    authController.myUser.value.hAddress!,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Office Address",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () async {
                source = authController.myUser.value.businessAddress!;
                sourceController.text = authController.myUser.value.bAddress!;


                if(markers.length >= 2) {
                  markers.remove(markers.last);
                }

                /// Add a marker on location
                markers.add(Marker(
                    markerId: MarkerId(authController.myUser.value.bAddress!),
                    infoWindow: InfoWindow(title: 'Source: ${authController.myUser.value.bAddress!}'),
                    position: source,
                    ));

                /// To draw polyline between two points in map
                // drawPolyline(authController.myUser.value.bAddress!);
                await getPolylines(source, destination);

                /// To animate the camera to new selected location
                mapController!.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(target: source, zoom: 15),
                  ),
                );

                setState(() {});

                Get.back();

                buildRideConfirmationSheet();
              },
              child: Container(
                width: Get.width,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          spreadRadius: 4,
                          blurRadius: 10)
                    ]),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    authController.myUser.value.bAddress!,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () async {
                Get.back();
                Prediction? p = await authController.showGoogleAutoComplete(context);

                String fromPlace = p!.description!;
                sourceController.text = fromPlace;

                /// To Location from address, basically Lat Lng of any location
                // List<geocoding.Location> locations =
                //     await geocoding.locationFromAddress(fromPlace);

                /// Get the actual lat and lng of location and store in destination
                // LatLng source = LatLng(locations.first.latitude,
                //     locations.first.longitude);

                source = await authController.buildLatLngFromAddress(fromPlace);


                if(markers.length >= 2) {
                  markers.remove(markers.last);
                }

                /// Add a marker on location
                markers.add(Marker(
                    markerId: MarkerId(fromPlace),
                    infoWindow: InfoWindow(title: 'Source: $fromPlace'),
                    position: source,
                    ));

                /// To draw polyline between two points in map
                // drawPolyline(fromPlace);
                await getPolylines(source, destination);

                /// To animate the camera to new selected location
                mapController!.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(target: source, zoom: 15),
                  ),
                );

                setState(() {});

                buildRideConfirmationSheet();
              },
              child: Container(
                width: Get.width,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          spreadRadius: 4,
                          blurRadius: 10)
                    ]),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Search for new location",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }


  buildRideConfirmationSheet() {
    Get.bottomSheet(Container(
      width: Get.width,
      height: Get.height * 0.4,
      padding: const EdgeInsets.only(left: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(12), topLeft: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              width: Get.width * 0.2,
              height: 8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.grey),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          textWidget(
              text: 'Select an option:',
              fontSize: 18,
              fontWeight: FontWeight.bold),
          const SizedBox(
            height: 20,
          ),
          buildDriversList(),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: buildPaymentCardWidget()),
                MaterialButton(
                  onPressed: () {},
                  child: textWidget(
                    text: 'Confirm',
                    color: Colors.white,
                  ),
                  color: AppColors.greenColor,
                  shape: const StadiumBorder(),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }

  int selectedRide = 0;

  buildDriversList() {
    return Container(
      height: 90,
      width: Get.width,
      child: StatefulBuilder(builder: (context, set) {
        return ListView.builder(
          itemBuilder: (ctx, i) {
            return InkWell(
              onTap: () {
                set(() {
                  selectedRide = i;
                });
              },
              child: buildDriverCard(selectedRide == i),
            );
          },
          itemCount: 3,
          scrollDirection: Axis.horizontal,
        );
      }),
    );
  }

  buildDriverCard(bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 8, left: 8, top: 4, bottom: 4),
      height: 85,
      width: 165,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: selected
                    ? Color(0xff2DBB54).withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                offset: Offset(0, 5),
                blurRadius: 5,
                spreadRadius: 1)
          ],
          borderRadius: BorderRadius.circular(12),
          color: selected ? Color(0xff2DBB54) : Colors.grey),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWidget(
                    text: 'Standard',
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
                textWidget(
                    text: '\$9.90',
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
                textWidget(
                    text: '3 MIN',
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.normal,
                    fontSize: 12),
              ],
            ),
          ),
          Positioned(
              right: -20,
              top: 0,
              bottom: 0,
              child: Image.asset('assets/Mask Group 2.png'))
        ],
      ),
    );
  }

  buildPaymentCardWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/visa.png',
            width: 40,
          ),
          const SizedBox(
            width: 10,
          ),
          DropdownButton<String>(
            value: list.first,
            icon: const Icon(Icons.keyboard_arrow_down),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(),
            onChanged: (String? value) {
              /// This is called when the user selects an item.

              setState(() {
               dropdownValue = value!;
              });
            },

            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: textWidget(text: value),
              );
            }).toList(),
          )
        ],
      ),
    );
  }




}
