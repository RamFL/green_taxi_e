import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';

class VehicleCompanyPage extends StatefulWidget {
  const VehicleCompanyPage(
      {Key? key, required this.selectedCompany, required this.onSelected})
      : super(key: key);

  final String selectedCompany;
  final Function onSelected;

  @override
  State<VehicleCompanyPage> createState() => _VehicleCompanyPageState();
}

class _VehicleCompanyPageState extends State<VehicleCompanyPage> {
  List<String> vehicleCompany = [
    'Honda',
    'Maruti',
    'TATA',
    'Ford',
    'Kia',
    'Mahindra'
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What is the company of vehicle?',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: ListView.builder(
            itemCount: vehicleCompany.length,
            itemBuilder: (context, i) {
              return ListTile(
                onTap: () => widget.onSelected(vehicleCompany[i]),
                visualDensity: const VisualDensity(vertical: -2),
                title: Text(vehicleCompany[i]),
                trailing: widget.selectedCompany == vehicleCompany[i]
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
