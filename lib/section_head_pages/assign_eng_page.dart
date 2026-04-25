import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/section_head_pages/shared_files/nav_bar.dart';
import 'package:greenlens/section_head_pages/shared_files/navbar_title.dart';

class Assign_Eng_Page extends StatefulWidget {
  const Assign_Eng_Page({super.key});

  @override
  State<Assign_Eng_Page> createState() => Assign_Eng_PageState();
}

class Assign_Eng_PageState extends State<Assign_Eng_Page> {
  int rows = 4;
  int columns = 4;
  final List<String> firstRowTexts = ['ID', 'Name', 'Email', 'Add &/Remove'];

  int _currentStep = 2;
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

        title: NavBarTitle(),

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
                      "Step 3 of 5",
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Assign Engineers",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: dividerColor),
            const SizedBox(height: 16),
            //table start from here --------------------------->
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Table(
                  border: TableBorder(
                    top: BorderSide(color: Colors.black, width: 1),
                    bottom: BorderSide(color: Colors.black, width: 1),
                    left: BorderSide(color: Colors.black, width: 1),
                    right: BorderSide(color: Colors.black, width: 1),
                    horizontalInside: BorderSide(color: Colors.black, width: 1),
                    verticalInside: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(0.25), // ID        → 1fr
                    1: FlexColumnWidth(1), // Name      → 2fr
                    2: FlexColumnWidth(1), // Email     → 3fr
                    3: FlexColumnWidth(0.35), // Add/Remove→ 1fr
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.white),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'ID',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.w600,color: primaryColor,fontSize: 24),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Name',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.w600,color: primaryColor,fontSize: 24),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text('Email', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.w600,color: primaryColor,fontSize: 24)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              'Add & \nRemove',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w600,color: primaryColor,fontSize: 24),
                            ),
                          ),
                        ),
                        // TODO Dynamic remaining rows
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('05', textAlign: TextAlign.start, style: TextStyle(fontSize: 24,fontWeight: FontWeight.w400)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Ahmad', textAlign: TextAlign.start, style: TextStyle(fontSize: 24,fontWeight: FontWeight.w400)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Ahmad@gmail.com',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 24,fontWeight: FontWeight.w400),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            height: 49,
                            width: 109.23,
                            decoration: BoxDecoration(
                              color: addengColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: addengColor,
                                padding:
                                    EdgeInsets.zero, // ✅ remove default padding
                                minimumSize: Size
                                    .zero, // ✅ remove minimum size constraint
                                tapTargetSize: MaterialTapTargetSize
                                    .shrinkWrap, // ✅ remove tap area padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: SvgPicture.asset(
                                'assets/images/Add.svg',
                                color: Colors.black,
                                width: 27,
                                height: 27,
                              ),
                            ),
                          ),
                          // TODO Dynamic remaining rows
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('11', textAlign: TextAlign.start, style: TextStyle(fontSize: 24,fontWeight: FontWeight.w400)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Mohammad', textAlign: TextAlign.start, style: TextStyle(fontSize: 24,fontWeight: FontWeight.w400)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Mohammad@gmail.com',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 24,fontWeight: FontWeight.w400),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            height: 49,
                            width: 109.23,
                            decoration: BoxDecoration(
                              color: removeEngColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: removeEngColor,
                                padding:
                                    EdgeInsets.zero, // ✅ remove default padding
                                minimumSize: Size
                                    .zero, // ✅ remove minimum size constraint
                                tapTargetSize: MaterialTapTargetSize
                                    .shrinkWrap, // ✅ remove tap area padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: SvgPicture.asset(
                                'assets/images/remove.svg',
                              ),
                            ),
                          ),
                          // TODO Dynamic remaining rows
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
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
                          'assets/images/Left Arrow.svg',
                          width: 40,
                          height: 40,
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
                            'assets/images/Left Arrow.svg',
                            width: 40,
                            height: 40,
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
