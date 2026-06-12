import 'package:flutter/material.dart';

/// Large "Assign Engineers" title displayed in the Assign Engineers flow AppBar.
class AssignEngNavBarTitle extends StatelessWidget {
  const AssignEngNavBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70, bottom: 30),
      child: Center(
        child: const Text(
          "Assign Engineers",
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
