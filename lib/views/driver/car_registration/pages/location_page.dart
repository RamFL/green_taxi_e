import 'package:flutter/material.dart';
import 'package:green_taxi_e/utils/app_colors.dart';

class LocationPage extends StatefulWidget {
  const LocationPage(
      {Key? key, required this.selectedLocation, required this.onSelect})
      : super(key: key);

  final String selectedLocation;
  final Function onSelect;

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  List<String> locations = [
    'India',
    'USA',
    'Canada',
    'Pakistan',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What Service Location you want to register?',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: ListView.builder(
            itemCount: locations.length,
            itemBuilder: (context, i) {
              return ListTile(
                onTap: () => widget.onSelect(locations[i]),
                visualDensity: const VisualDensity(vertical: -2),
                title: Text(locations[i]),
                trailing: widget.selectedLocation == locations[i]
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
