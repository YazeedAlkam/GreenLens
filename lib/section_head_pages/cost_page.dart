import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
//import 'package:greenlens/section_head_pages/shared_files/fotter.dart';
import 'package:greenlens/section_head_pages/shared_files/nav_bar.dart';
import 'package:greenlens/section_head_pages/shared_files/navbar_title.dart';

class costpage extends StatefulWidget {
  const costpage({super.key});

  @override
  State<costpage> createState() => _costpageState();
}

class _costpageState extends State<costpage> {
  int _currentStep = 3;
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
                      "Step 4 of 5",
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
            // ── Header ───────────────────────────────────────────────────────
            Row(
              children: [
                Text(
                  'Project Costs',
                  style: GoogleFonts.firaSans(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const Divider(),
            // ── Client ID ───────────────────────────────────────────────────
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Client ID",
                style: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10, width: double.infinity),
            SizedBox(
              height: 65,
              child: TextField(
                readOnly: true,
                expands: true,
                maxLines: null,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: disableColor,
                  hoverColor: disableColor,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10, width: double.infinity),
            // ── Contact tabs ─────────────────────────────────────────────────
            //Tax
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Tax",
                style: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10, width: double.infinity),
            SizedBox(
              height: 65,
              child: TextField(
                readOnly: true,
                expands: true,
                maxLines: null,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: "5%",
                  filled: true,
                  fillColor: disableColor,
                  hoverColor: disableColor,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10, width: double.infinity),
            //Transportation Cost
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Transportation Costs",
                style: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10, width: double.infinity),
            SizedBox(
              height: 65,
              child: TextField(
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: "e.g 100JD",
                  filled: true,
                  fillColor: Colors.white,
                  hoverColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10, width: double.infinity),
            //Machinery Operating Cost
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Machinery Operating Costs",
                style: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10, width: double.infinity),
            SizedBox(
              height: 65,
              child: TextField(
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: "e.g 30 JOD",
                  filled: true,
                  fillColor: Colors.white,
                  hoverColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10, width: double.infinity),
            //Other Costs
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Other Costs",
                style: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10, width: double.infinity),
            SizedBox(
              height: 65,
              child: TextField(
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: "e.g 30 JOD",
                  filled: true,
                  fillColor: Colors.white,
                  hoverColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10, width: double.infinity),
            //Total Costs
            //TODO: make it auto calculated by the app
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Total Costs",
                style: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10, width: double.infinity),
            SizedBox(
              height: 65,
              child: TextField(
                readOnly: true,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: "----",
                  filled: true,
                  fillColor: addengColor,
                  hoverColor: addengColor,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            //TODO: add the buttons class here
          ],
        ),
      ),
    );
  }
}
