import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greenlens/SectionHead/NavBar.dart';
import 'package:greenlens/main.dart';
import 'package:google_fonts/google_fonts.dart';

class Clientinfo extends StatefulWidget {
  const Clientinfo({super.key});

  @override
  State<Clientinfo> createState() => _ClientinfoState();
}

class _ClientinfoState extends State<Clientinfo> {
  int _currentStep = 0;
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
                SizedBox(
                  width: 75,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: SvgPicture.asset(
                      'assets/images/aroowofclientinfo.svg',
                    ),
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
          ],
        ),
      ),
    );
  }
}
