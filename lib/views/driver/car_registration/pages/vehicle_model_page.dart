import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';

class VehicleModelPage extends StatefulWidget {
  const VehicleModelPage(
      {Key? key, required this.selectedModel, required this.onSelected})
      : super(key: key);

  final String selectedModel;
  final Function onSelected;

  @override
  State<VehicleModelPage> createState() => _VehicleModelPageState();
}

class _VehicleModelPageState extends State<VehicleModelPage> {
  List<String> vehicleModel = [
    'Amanti',
    'Borrego',
    'Cadenza',
    'Forte',
    'K900',
    'Niro',
    'Optima',
    'Rio',
    'Rondo',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What model of vehicle is it ?',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: ListView.builder(
            itemCount: vehicleModel.length,
            itemBuilder: (context, i) {
              return ListTile(
                onTap: () => widget.onSelected(vehicleModel[i]),
                visualDensity: const VisualDensity(vertical: -2),
                title: Text(vehicleModel[i]),
                trailing: widget.selectedModel == vehicleModel[i]
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
