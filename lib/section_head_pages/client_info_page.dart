import 'package:flutter/material.dart';
import 'package:greenlens/main.dart';

class Clientinfo extends StatelessWidget {
  const Clientinfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            Text(
              "Create New Project",
              style: TextStyle(
                fontSize: 64.8,
                color: Colors.white,
                fontFamily: 'TimesNewRoman',
              ),
            ),
            Text(
              "Step 1 of 4",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 26),
            ),
            SizedBox(height: 10),
            Text(
              "subtitle",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 26),
            ),
          ],
        ),
      ),
    );
  }
}
