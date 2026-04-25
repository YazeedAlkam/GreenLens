import 'package:flutter/material.dart';

class NavBarTitle extends StatelessWidget {
  const NavBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.only(top: 70,bottom: 30),
          child: Center(
            child: const Text(
              "Create New Project",
              overflow: TextOverflow.visible,
              softWrap: false,
              style: TextStyle(
                fontSize: 65,
                color: Colors.white,
                fontFamily: 'TimesNewRoman',
                height:3,
              ),
              textAlign: TextAlign.center,
              
            ),
          ),
        );
  }
}