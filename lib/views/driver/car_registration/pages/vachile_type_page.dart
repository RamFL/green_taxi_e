import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';

class VehicleTypePage extends StatefulWidget {
  const VehicleTypePage({Key? key, required this.selectedCarType, required this.onSelected}) : super(key: key);

  final String selectedCarType;
  final Function onSelected;

  @override
  State<VehicleTypePage> createState() => _VehicleTypePageState();
}

class _VehicleTypePageState extends State<VehicleTypePage> {
  List<String> vehicleType = ['Economy', 'Business', 'Middle'];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What type of vehicle is it?',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: ListView.builder(
            itemCount: vehicleType.length,
            itemBuilder: (context, i) {
              return ListTile(
                onTap: () => widget.onSelected(vehicleType[i]),
                visualDensity: const VisualDensity(vertical: -2),
                title: Text(vehicleType[i]),
                trailing: widget.selectedCarType == vehicleType[i]
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: AppColors.greenColor,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              );
            },
          ),
        ),
      ],
    );
  }
}
