import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/section_head_pages/shared_files/fotter.dart';

class ProjectInfoBody extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final VoidCallback onViewBills;

  const ProjectInfoBody({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    required this.onViewBills,
  });

  @override
  State<ProjectInfoBody> createState() => _ProjectInfoBodyState();
}

class _ProjectInfoBodyState extends State<ProjectInfoBody> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 30),
      child: Column(
        children: [
          // ── Header ───────────────────────────────────────────────────────
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
          const Divider(),

          // ── Project Name ─────────────────────────────────────────────────
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
          const SizedBox(height: 16),
          SizedBox(
            height: 65,
            child: TextField(
              expands: true,
              maxLines: null,
              style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: "e.g Commercial",
                hintStyle: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF808080),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // ── Row 1: Building Type + Floor Area ────────────────────────────
          Row(
            children: [
              Expanded(
                child: Text(
                  "Building Type",
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  "Floor Area (m²)",
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 65,
                  child: TextField(
                    expands: true,
                    maxLines: null,
                    style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: "e.g Commercial",
                      hintStyle: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF808080),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xFF808080),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xFF808080),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 65,
                  child: TextField(
                    expands: true,
                    maxLines: null,
                    style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: "e.g 5000",
                      hintStyle: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF808080),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xFF808080),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xFF808080),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // ── Row 2: No. of Floors + Operating hrs/day ─────────────────────
          Row(
            children: [
              Expanded(
                child: Text(
                  "No. of Floors",
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  "Operating hrs/day",
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 65,
                  child: TextField(
                    expands: true,
                    maxLines: null,
                    style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: "e.g 4",
                      hintStyle: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF808080),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xFF808080),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xFF808080),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 65,
                  child: TextField(
                    expands: true,
                    maxLines: null,
                    style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: "e.g 12",
                      hintStyle: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF808080),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xFF808080),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xFF808080),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // ── Row 3: Days/week + Average Monthly Bill ───────────────────────
          Row(
            children: [
              Expanded(
                child: Text(
                  "Days/week",
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  "Average Monthly Bill (Past 12 Months)",
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 65,
                  child: TextField(
                    expands: true,
                    maxLines: null,
                    style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: "e.g 6",
                      hintStyle: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF808080),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xFF808080),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xFF808080),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 65,
                  child: TextField(
                    readOnly: true,
                    expands: true,
                    maxLines: null,
                    style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: disableColor,
                      hoverColor: disableColor,
                      hintText: "No Data",
                      hintStyle: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF808080),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () {
                            widget.onViewBills();
                          },
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.diagonal3Values(-1.0, 1.0, 1.0),
                            child: SvgPicture.asset(
                              'assets/images/Left Arrow.svg',
                              width: 40,
                              height: 40,
                              colorFilter: ColorFilter.mode(
                                Colors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                      suffixIconConstraints: BoxConstraints(
                        minWidth: 0,
                        minHeight: 0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xFF808080),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xFF808080),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // ── Row 4: Initiation Date + Deadline Date ────────────────────────
          Row(
            children: [
              Expanded(
                child: Text(
                  "Initiation Date",
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  "Deadline Date*",
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 65,
                  child: TextField(
                    expands: true,
                    maxLines: null,
                    style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: "e.g 6th of June, 2026",
                      hintStyle: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF808080),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xFF808080),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xFF808080),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 65,
                  child: TextField(
                    expands: true,
                    maxLines: null,
                    style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: "e.g 18th of September, 2026",
                      hintStyle: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF808080),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xFF808080),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xFF808080),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Sales Mark ───────────────────────────────────────────────────
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
          const SizedBox(height: 16),
          SizedBox(
            child: TextField(
              maxLines: 4,
              style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: "Short Description about Sales Mark",
                hintStyle: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF808080),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // ── Footer ───────────────────────────────────────────────────────
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
