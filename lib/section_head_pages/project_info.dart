import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/section_head_pages/NavBar.dart';
import 'package:greenlens/section_head_pages/navbar_title.dart';

class Project_Info_Page extends StatefulWidget {
  const Project_Info_Page({super.key});

  @override
  State<Project_Info_Page> createState() => _Project_Info_PageState();
}

class _Project_Info_PageState extends State<Project_Info_Page> {
  int _currentStep = 0;

  void next() {
    if (_currentStep < 4) setState(() => _currentStep++);
  }

  void _back() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 200,
        backgroundColor: primaryColor,
        elevation: 10,
        automaticallyImplyLeading: false,

        title: Navbar_Title(),

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
                      "Step 2 of 5",
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
        padding: const EdgeInsets.only(left: 32, right: 32, top: 30),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Project Info',
                  style: GoogleFonts.firaSans(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Project Name",
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: "e.g Commercial",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
              ),
            ),
            SizedBox(height: 16),
            //row Number 1
            Row(
              children: [
                Text(
                  "Building Type",
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 336),
                Text(
                  "Floor Area (m²)",
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  // 👈
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "e.g Commercial",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16), // spacing between the two fields
                Expanded(
                  // 👈
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "e.g 5000",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            //row Number 2
            Row(
              children: [
                Text(
                  "No. of Floors",
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 345),
                Text(
                  "Operating hrs/day",
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  // 👈
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "e.g 4",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16), // spacing between the two fields
                Expanded(
                  // 👈
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "e.g 12",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            //row Number 3
            Row(
              children: [
                Text(
                  "Days/week",
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 367),
                Text(
                  "Average Monthly Bill (Past 12 Months)",
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  // 👈
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "e.g 6",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16), // spacing between the two fields
                Expanded(
                  // 👈
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "e.g 3200",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            //row Number 4
            Row(
              children: [
                Text(
                  "Initiation Date",
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 336),
                Text(
                  "Deadline Date*",
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  // 👈
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "e.g 6th of June, 2026 ",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16), // spacing between the two fields
                Expanded(
                  // 👈
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "e.g 18th of September, 2026",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  "Sales Mark",
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Short Description about Sales Mark",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 183,
                  height: 65,
                  child: ElevatedButton(
                    onPressed: _back,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: const BorderSide(color: Colors.black, width: 1.5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/aroowofclientinfo.svg',
                          width: 27,
                          height: 17,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Back",
                          style: GoogleFonts.firaSans(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 17),
                Container(
                  width: 309,
                  height: 65,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: const BorderSide(color: Colors.black, width: 1.5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Save Draft",
                          style: GoogleFonts.firaSans(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 17),
                Container(
                  width: 434,
                  height: 65,
                  child: ElevatedButton(
                    onPressed: next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: const BorderSide(color: Colors.black, width: 1.5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Next Step",
                          style: GoogleFonts.firaSans(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..scale(-1.0, 1.0),
                          child: SvgPicture.asset(
                            'assets/images/aroowofclientinfo.svg',
                            width: 27,
                            height: 17,
                            color: Colors.white,
                          ),
                        ),
                      ],
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
