import 'package:flutter/material.dart';
import 'package:green_taxi_e/utils/app_colors.dart';

Widget decisionButton(
    String icon, String text, Function onPressed, double width,
    {double height = 50}) {
  return InkWell(
    onTap: () => onPressed(),
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 65,
            height: height,
            decoration: const BoxDecoration(
              color: AppColors.greenColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Image.asset(icon, height: 5, width: 5,),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
  );
}
