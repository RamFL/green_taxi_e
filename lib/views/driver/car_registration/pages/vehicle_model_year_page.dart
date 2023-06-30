import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';

class VehicleModelYearPage extends StatefulWidget {
  const VehicleModelYearPage({Key? key, required this.onSelected})
      : super(key: key);

  final Function onSelected;

  @override
  State<VehicleModelYearPage> createState() => _VehicleModelYearPageState();
}

class _VehicleModelYearPageState extends State<VehicleModelYearPage> {
  List<int> years = [
    2005,
    2006,
    2007,
    2008,
    2009,
    2010,
    2011,
    2012,
    2013,
    2014,
    2015,
    2016,
    2017,
    2018,
    2019,
    2020,
    2021,
    2022,
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What is the vehicle model year ?',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: CupertinoPicker.builder(
            childCount: years.length,
            itemExtent: 80,
            onSelectedItemChanged: (value) {
              widget.onSelected(years[value]);
            },
            itemBuilder: (context, index) {
              return Center(
                child: Text(
                  years[index].toString(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
