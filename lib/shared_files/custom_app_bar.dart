import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greenlens/main.dart';

class CustomAppBar {
  static AppBar build({required String title, required String subtitle}) {
    return AppBar(
      backgroundColor: primaryColor,
      toolbarHeight: 316,
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      elevation: 10,
      shadowColor: Colors.black,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/GreenLensLogo.svg', height: 100),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 64, fontFamily: "TimesNewRoman"),
          ),
          SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 26),
          ),
        ],
      ),
    );
  }
}
