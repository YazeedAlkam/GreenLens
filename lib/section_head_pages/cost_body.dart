import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/section_head_pages/shared_files/fotter.dart';

class CostBody extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;

  const CostBody({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
  });

  @override
  State<CostBody> createState() => _CostBodyState();
}

class _CostBodyState extends State<CostBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 30),
      child: Column(
        children: [
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
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Engineers Expected Cost",
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
                hintText: "No Data",
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
          const SizedBox(height: 32),
          CreateNewProjectFooter(
            currentStep: widget.currentStep,
            onNext: widget.onNext,
            onBack: widget.onBack,
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
