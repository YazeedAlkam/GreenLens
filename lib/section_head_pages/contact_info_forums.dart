import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainClientForum extends StatefulWidget {
  const MainClientForum({super.key});

  @override
  State<MainClientForum> createState() => _MainClientForumState();
}

class _MainClientForumState extends State<MainClientForum> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black, width: 2),
      ),
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Client Full Name',
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 65,
              child: TextField(
                expands: true,
                maxLines: null,
                style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: "e.g Mohammed",
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
            SizedBox(height: 30),
            Text(
              'Client Position',
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 65,
              child: TextField(
                expands: true,
                maxLines: null,
                style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: "e.g CEO",
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
            SizedBox(height: 30),
            Row(
              children: [
                Text(
                  'Client Email',
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 336),
                Text(
                  'Client Phone Number',
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
                  child: SizedBox(
                    height: 65,
                    child: TextField(
                      expands: true,
                      maxLines: null,
                      style: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: "e.g example@example.com",
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
                SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 65,
                    child: TextField(
                      expands: true,
                      maxLines: null,
                      style: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: "e.g +962 79 7786 498",
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
          ],
        ),
      ),
    );
  }
}

class OtherContactsForum extends StatefulWidget {
  const OtherContactsForum({super.key});

  @override
  State<OtherContactsForum> createState() => _OtherContactsForumState();
}

class _OtherContactsForumState extends State<OtherContactsForum> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black, width: 2),
      ),
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Full Name',
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 65,
              child: TextField(
                expands: true,
                maxLines: null,
                style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: "e.g Mohammed",
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
            SizedBox(height: 30),
            Text(
              'Position',
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 65,
              child: TextField(
                expands: true,
                maxLines: null,
                style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: "e.g CEO",
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
            SizedBox(height: 30),
            Row(
              children: [
                Text(
                  'Email',
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 404),
                Text(
                  'Phone Number',
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
                  child: SizedBox(
                    height: 65,
                    child: TextField(
                      expands: true,
                      maxLines: null,
                      style: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: "e.g example@example.com",
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
                SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 65,
                    child: TextField(
                      expands: true,
                      maxLines: null,
                      style: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: "e.g +962 79 7786 498",
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
          ],
        ),
      ),
    );
  }
}
