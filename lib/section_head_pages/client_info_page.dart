// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greenlens/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/section_head_pages/shared_files/nav_bar.dart';
import 'package:greenlens/section_head_pages/shared_files/navbar_title.dart';
import 'package:greenlens/section_head_pages/contact_info_forums.dart';

class Clientinfo extends StatefulWidget {
  const Clientinfo({super.key});

  @override
  State<Clientinfo> createState() => _ClientinfoState();
}

class _ClientinfoState extends State<Clientinfo> {
  int _currentStep = 0;

  /// Tracks which contact tab is currently active:
  /// 0 = Client Contact, 1 = Second Contact, 2+ = extra contacts
  int _activeContact = 0;

  /// Holds IDs for dynamically added extra contact tabs (beyond the first two)
  List<int> _extraContacts = [];
  int _nextContactId = 2;

  void _next() {
    if (_currentStep < 4) setState(() => _currentStep++);
  }

  void _back() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  /// Returns the label for an extra contact tab given its id
  String _extraContactLabel(int id) => "Contact ${id + 1}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

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
                      "Step 1 of 5",
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
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: SvgPicture.asset('assets/images/Left Arrow.svg'),
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
            Divider(color: Color(0xFFa8a6a7), height: 2, thickness: 2),
            SizedBox(height: 16, width: double.infinity,),
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
            SizedBox(height: 16,width: double.infinity,),
            SizedBox(
              height: 65,
              child: TextField(
                readOnly: true,
                expands: true,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: "52",
                  labelStyle: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  filled: true,
                  fillColor: disableColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(width: 2, color: Color(0xFF707070)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16, width: double.infinity,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // ── "Client Contact" tab ──
                  _ContactTabButton(
                    label: "Client Contact",
                    isActive: _activeContact == 0,
                    width: 423,
                    onTap: () => setState(() => _activeContact = 0),
                  ),
                  const SizedBox(width: 18),

                  // ── "Second Contact" tab ──
                  _ContactTabButton(
                    label: "Second Contact",
                    isActive: _activeContact == 1,
                    width: 423,
                    onTap: () => setState(() => _activeContact = 1),
                  ),
                  const SizedBox(width: 18),

                  // ── Dynamically added extra contact tabs ──
                  ..._extraContacts.map((id) {
                    return Row(
                      children: [
                        _ContactTabButton(
                          label: _extraContactLabel(id),
                          isActive: _activeContact == id,
                          width: 260,
                          onTap: () => setState(() => _activeContact = id),
                        ),
                        const SizedBox(width: 18),
                      ],
                    );
                  }),

                  // ── "+" button ──
                  Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: SizedBox.expand(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _extraContacts.add(_nextContactId);
                            // Auto-switch to the newly added tab
                            _activeContact = _nextContactId;
                            _nextContactId++;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            side: const BorderSide(
                              width: 0,
                              color: Colors.transparent,
                            ),
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
            ),
            SizedBox(height: 16, width: double.infinity,),
            // ── Contact form (switches based on active tab) ─────────────────
            if (_activeContact == 0)
              MainClientForum()
            else
              OtherContactsForum(), // shown for Second Contact and any extra contacts

            const SizedBox(height: 129, width: double.infinity),
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

class _ContactTabButton extends StatelessWidget {
  const _ContactTabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.width = 423,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 78,
      decoration: BoxDecoration(
        color: isActive ? primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isActive ? const Color(0xFF0d123f) : const Color(0xFF808080),
          width: 2,
        ),
      ),
      child: SizedBox.expand(
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(width: 0, color: Colors.transparent),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.firaSans(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}