import 'package:flutter/material.dart';

/// Large "Audit Data Entry" title displayed in the wizard's AppBar above the
/// step indicator.
class NavBarTitleEng extends StatelessWidget {
  const NavBarTitleEng({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70, bottom: 30),
      child: Center(
        child: const Text(
          "Audit Data Entry",
          overflow: TextOverflow.visible,
          softWrap: false,
          style: TextStyle(
            fontSize: 65,
            color: Colors.white,
            fontFamily: 'TimesNewRoman',
            height: 3,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
