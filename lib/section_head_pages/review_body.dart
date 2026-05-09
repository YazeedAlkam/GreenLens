import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/section_head_pages/shared_files/fotter.dart';

class ReviewBody extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final VoidCallback onViewAllContacts;

  const ReviewBody({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    required this.onViewAllContacts,
  });

  @override
  State<ReviewBody> createState() => _ReviewBodyState();
}

class _ReviewBodyState extends State<ReviewBody> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────────────
            Row(
              children: [
                Text(
                  'Review',
                  style: GoogleFonts.firaSans(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Client Info",
                  style: GoogleFonts.firaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            // ── Client Info Table - main client ─────────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: tablelinescolor, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Table(
                border: TableBorder.symmetric(
                  inside: BorderSide(color: tablelinescolor, width: 2),
                ),
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              "ID",
                              style: GoogleFonts.firaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "52",
                              style: GoogleFonts.firaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Text(
                              "Full Name",
                              style: GoogleFonts.firaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "Example .e Example",
                              style: GoogleFonts.firaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Text(
                              "Client Position",
                              style: GoogleFonts.firaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "CEO",
                              style: GoogleFonts.firaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Text(
                              "Client Email",
                              style: GoogleFonts.firaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "example@example.com",
                              style: GoogleFonts.firaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Text(
                              "Client Phone Number",
                              style: GoogleFonts.firaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "123-456-7890",
                              style: GoogleFonts.firaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextButton(
                          onPressed: () {
                            widget.onViewAllContacts();
                          },
                          style: TextButton.styleFrom(
                            overlayColor: Colors.transparent,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "View All Contacts",
                                  style: GoogleFonts.firaSans(
                                    color: Colors.black,
                                    fontSize: 24,
                                  ),
                                ),
                                SvgPicture.asset(
                                  "assets/images/arrowright.svg",
                                  width: 40,
                                  height: 40,
                                  colorFilter: ColorFilter.mode(
                                    primaryColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Divider(),
            //Project Info
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Project Info",
                  style: GoogleFonts.firaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: tablelinescolor, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Table(
                border: TableBorder.symmetric(
                  inside: BorderSide(color: tablelinescolor, width: 2),
                ),
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              "Project Name",
                              style: GoogleFonts.firaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "Facility Name...",
                              style: GoogleFonts.firaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Text(
                              "Building Type",
                              style: GoogleFonts.firaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "Commercial",
                              style: GoogleFonts.firaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Text(
                              "Initiation Date",
                              style: GoogleFonts.firaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "6th of June, 2026",
                              style: GoogleFonts.firaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Text(
                              "Deadline Date",
                              style: GoogleFonts.firaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "18th of September, 2026",
                              style: GoogleFonts.firaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Divider(),
            //Assign Engs
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Assigned Engineers",
                  style: GoogleFonts.firaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: tablelinescolor, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(0.19), // first column
                  1: FlexColumnWidth(2), // second column
                  2: FlexColumnWidth(1), // third column
                },
                border: TableBorder.symmetric(
                  inside: BorderSide(color: tablelinescolor, width: 2),
                ),
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'ID',
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Name',
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Contact Info',
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("11", style: GoogleFonts.firaSans(fontSize: 24)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Mohmmad", style: GoogleFonts.firaSans(fontSize: 24)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "example@example.com",
                              style: GoogleFonts.firaSans(fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("11", style: GoogleFonts.firaSans(fontSize: 24)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Mohmmad", style: GoogleFonts.firaSans(fontSize: 24)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "example@example.com",
                              style: GoogleFonts.firaSans(fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("11", style: GoogleFonts.firaSans(fontSize: 24)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Mohmmad", style: GoogleFonts.firaSans(fontSize: 24)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "example@example.com",
                              style: GoogleFonts.firaSans(fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            CreateNewProjectFooter(
              currentStep: widget.currentStep,
              onNext: widget.onNext,
              onBack: widget.onBack,
              mode: FooterMode.review,
            ),
            const SizedBox(height: 6000),
          ],
        ),
      ),
    );
  }
}
