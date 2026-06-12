import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greenlens/main.dart';

/// Utility class providing the standard app bar used across all dashboard and flow screens.
class CustomAppBar {
  /// Builds and returns the standard deep-indigo [AppBar] with the GreenLens
  /// logo, a large [title], and a smaller [subtitle] below it.
  static AppBar build({required String title, required String subtitle}) {
    return AppBar(
      backgroundColor: primaryColor,
      toolbarHeight: 316,
      centerTitle: true,
      elevation: 10,
      shadowColor: Colors.black,
      automaticallyImplyLeading: false,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/GreenLensLogo.svg', height: 100),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 64,
              fontFamily: "TimesNewRoman",
            ),
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
