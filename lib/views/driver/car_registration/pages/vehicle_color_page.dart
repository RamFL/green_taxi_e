import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleColorPage extends StatefulWidget {
  const VehicleColorPage({Key? key, required this.onSelectedColor})
      : super(key: key);

  final Function onSelectedColor;

  @override
  State<VehicleColorPage> createState() => _VehicleColorPageState();
}

class _VehicleColorPageState extends State<VehicleColorPage> {
  String dropDownValue = 'Pick a color';

  List<String> colors = [
    'Pick a color',
    'White',
    "Red",
    "Black",
    'Grey',
    'Blue'
  ];

  buildDropDown() {
    return Container(
      width: Get.width,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      // height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 1)
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton(
        value: dropDownValue,
        isExpanded: true,
        underline: Container(),
        icon: const Icon(Icons.arrow_drop_down_outlined),
        items: colors.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
        // After selecting the desired option,it will
        // change button value to selected value
        onChanged: (String? newValue) {
          setState(() {
            dropDownValue = newValue!;
          });
          widget.onSelectedColor(newValue!);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'What is the color of your vehicle ?',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        const SizedBox(height: 30),
        buildDropDown(),
      ],
    );
  }
}
