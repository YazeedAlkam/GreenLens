import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';

class LightingReview extends StatelessWidget {
  const LightingReview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 30, 32, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────────────
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: SvgPicture.asset('assets/images/Left Arrow.svg'),
                ),
                Text(
                  ' Lighting Breakdown',
                  style: GoogleFonts.firaSans(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            Divider(color: dividerColor),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Area 1",
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
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Table(
                  border: TableBorder.symmetric(
                    inside: BorderSide(color: tablelinescolor, width: 2),
                  ),
                  children: [
                    //Row -1-
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Text(
                                "Type",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "LED",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //Row -2-
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Text(
                                "No of lights",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "10",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //Row -3-
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Text(
                                "Rated Power",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "25 W",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //Row -4-
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Text(
                                "Usage (Hrs / Year)",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "2400 Hrs",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //Row -5-
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Text(
                                "Total Energy Cost / Year",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "20 JD",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //Row -6-
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Text(
                                "Total kWh / Year",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "200 kWh",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
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
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  "Area 2",
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
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Table(
                  border: TableBorder.symmetric(
                    inside: BorderSide(color: tablelinescolor, width: 2),
                  ),
                  children: [
                    //Row -1-
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Text(
                                "Type",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "LED",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //Row -2-
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Text(
                                "No of lights",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "10",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //Row -3-
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Text(
                                "Rated Power",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "25 W",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //Row -4-
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Text(
                                "Usage (Hrs / Year)",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "2400 Hrs",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //Row -5-
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Text(
                                "Total Energy Cost / Year",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "20 JD",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //Row -6-
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Text(
                                "Total kWh / Year",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "200 kWh",
                                style: GoogleFonts.firaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
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
            ),
            SizedBox(height: 10000,)
          ],
        ),
      ),
    );
  }
}
