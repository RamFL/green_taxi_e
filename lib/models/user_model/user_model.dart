import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserModel {
  String? bAddress;
  String? hAddress;
  String? mallAddress;
  String? name;
  String? image;
  
  LatLng? homeAddress;
  LatLng? businessAddress;
  LatLng? shoppingAddress;

  UserModel({this.name, this.image, this.bAddress, this.hAddress, this.mallAddress});

  UserModel.fromJson(Map<String, dynamic> json) {
    bAddress = json['business_address'];
    hAddress = json['home_address'];
    mallAddress = json['shopping_address'];
    name = json['name'];
    image = json['profileImage'];
    homeAddress = LatLng(json['home_latlng'].latitude, json['home_latlng'].longitude);
    businessAddress = LatLng(json['business_latlng'].latitude, json['business_latlng'].longitude);
    shoppingAddress = LatLng(json['shopping_latlng'].latitude, json['shopping_latlng'].longitude);
  }
}
