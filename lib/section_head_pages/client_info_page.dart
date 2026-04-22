// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greenlens/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/section_head_pages/NavBar.dart';
import 'package:greenlens/section_head_pages/clientcontact.dart';

class Clientinfo extends StatefulWidget {
  const Clientinfo({super.key});

  @override
  State<Clientinfo> createState() => _ClientinfoState();
}

class _ClientinfoState extends State<Clientinfo> {
  int _currentStep = 0;

  void _next() {
    if (_currentStep < 4) setState(() => _currentStep++);
  }

  void _back() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        toolbarHeight: 200,
        backgroundColor: primaryColor,
        elevation: 10,
        automaticallyImplyLeading: false,

        title: Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Center(
            child: const Text(
              "Create New Project",
              style: TextStyle(
                fontSize: 65,
                color: Colors.white,
                fontFamily: 'TimesNewRoman',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const Text(
                      "Step 1 of 4",
                      style: TextStyle(color: Colors.white, fontSize: 26),
                    ),
                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.only(left: 90, right: 40),
                      //here is how u can call the animated navbar 
                      child: NavigationBarLines(
                        currentStep: _currentStep,
                        onStepTapped: (step) =>
                            setState(() => _currentStep = step),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Row(
              children: [
                //for this one i dont know if it will work or not xD
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, // 🔥 remove internal padding
                    minimumSize: Size.zero, // 🔥 remove default min size
                    tapTargetSize:
                        MaterialTapTargetSize.shrinkWrap, // 🔥 shrink tap area
                    elevation: 0,
                    backgroundColor: Colors.transparent, // optional
                    shadowColor: Colors.transparent,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/aroowofclientinfo.svg',
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  "Client Info",
                  style: GoogleFonts.firaSans(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            Divider(color: textcolor),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  "Client ID",
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 65,
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: disableColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 423,
                  height: 78,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    child: Text(
                      "Client Contact",
                      style: GoogleFonts.firaSans(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 18),
                Container(
                  width: 423,
                  height: 78,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.black),
                  ),
                  child: SizedBox.expand(
                    // 👈 forces full size
                    //here in this button it should move to the second contact info form (same form but empty one)
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0, // 👈 remove shadow
                        padding: EdgeInsets.zero, // 👈 VERY IMPORTANT
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            18,
                          ), // 👈 match container
                        ),
                      ),
                      child: Text(
                        "Second Contact",
                        style: GoogleFonts.firaSans(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 18),
                Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.black),
                  ),
                  child: SizedBox.expand(
                    //here in this button it should be everytime he click it should add another contact info form
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero, // 👈 IMPORTANT
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            18,
                          ), // 👈 match container
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/images/add.svg',
                        width: 51,
                        height: 51,
                        colorFilter: ColorFilter.mode(
                          addclientbuttoncolor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Client Info Form -------------------->
            Addclient(),
            SizedBox(height: 129),
            //the Buttons connected to the nav bar -------------------->
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _currentStep > 0 ? _back : null,
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor.withOpacity(0.15),
                      foregroundColor: primaryColor,
                      disabledForegroundColor: Colors.grey.withOpacity(0.4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text('Back'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Save Draft",
                      style: GoogleFonts.firaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _currentStep < 4 ? _next : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(_currentStep == 4 ? 'Submit' : 'Next Step'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
