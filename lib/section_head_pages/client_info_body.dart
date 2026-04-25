// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greenlens/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/section_head_pages/contact_info_forums.dart';
import 'package:greenlens/section_head_pages/shared_files/fotter.dart';

class ClientInfoBody extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;

  const ClientInfoBody({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
  });

  @override
  State<ClientInfoBody> createState() => _ClientInfoBodyState();
}

class _ClientInfoBodyState extends State<ClientInfoBody> {
  /// Tracks which contact tab is currently active:
  /// 0 = Client Contact, 1 = Second Contact, 2+ = extra contacts
  int _activeContact = 0;

  /// Holds IDs for dynamically added extra contact tabs (beyond the first two)
  final List<int> _extraContacts = [];
  int _nextContactId = 2;

  /// Returns the label for an extra contact tab given its id
  String _extraContactLabel(int id) => "Contact ${id + 1}";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          // ── Header row ──────────────────────────────────────────────────
          Row(
            children: [
              ElevatedButton(
                onPressed: widget.onBack,
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
              const SizedBox(width: 10),
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

          Divider(color: const Color(0xFFa8a6a7), height: 2, thickness: 2),
          const SizedBox(height: 16, width: double.infinity),

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
          const SizedBox(height: 16, width: double.infinity),
          SizedBox(
            height: 65,
            child: TextField(
              readOnly: true,
              expands: true,
              maxLines: null,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: "52",
                hintStyle: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                filled: true,
                fillColor: disableColor,
                hoverColor: disableColor,
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
          const SizedBox(height: 16, width: double.infinity),

          // ── Contact tabs ─────────────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _ContactTabButton(
                  label: "Client Contact",
                  isActive: _activeContact == 0,
                  width: 423,
                  onTap: () => setState(() => _activeContact = 0),
                ),
                const SizedBox(width: 18),
                _ContactTabButton(
                  label: "Second Contact",
                  isActive: _activeContact == 1,
                  width: 423,
                  onTap: () => setState(() => _activeContact = 1),
                ),
                const SizedBox(width: 18),

                // Dynamically added extra contact tabs
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

                // "+" button
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

          const SizedBox(height: 16, width: double.infinity),

          // ── Contact form ─────────────────────────────────────────────────
          if (_activeContact == 0) MainClientForum() else OtherContactsForum(),

          const SizedBox(height: 32),

          // ── Footer ───────────────────────────────────────────────────────
          CreateNewProjectFooter(
            currentStep: widget.currentStep,
            onNext: widget.onNext,
            onBack: widget.onBack,
          ),
        ],
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
