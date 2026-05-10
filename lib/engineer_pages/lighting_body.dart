import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/engineer_pages/Area_info_forums.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/section_head_pages/shared_files/fotter.dart';

class LightingBody extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  const LightingBody({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
  });

  @override
  State<LightingBody> createState() => _LightingBodyState();
}

class _LightingBodyState extends State<LightingBody> {
  /// Tracks which Area tab is currently active:
  /// 0 = Main Floor, 1 = Area 2, 2+ = extra areas
  int _activeArea = 0;

  /// Holds IDs for dynamically added extra area tabs (beyond the first two)
  final List<int> _extraAreas = [];
  int _nextAreaId = 2;

  /// Returns the label for an extra areas tab given its id
  String _extraAreaLabel(int id) => "Contact ${id + 1}";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 30),
      child: Column(
        children: [
          Text(
            "Lighting Systems",
            style: GoogleFonts.firaSans(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const Divider(color: dividerColor),
          //Area's Button
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _AreaTabButton(
                  label: "Area 1",
                  isActive: _activeArea == 0,
                  width: 423,
                  onTap: () => setState(() => _activeArea = 0),
                ),
                const SizedBox(width: 18),
                _AreaTabButton(
                  label: "Area 2",
                  isActive: _activeArea == 1,
                  width: 423,
                  onTap: () => setState(() => _activeArea = 1),
                ),
                const SizedBox(width: 18),

                // Dynamically added extra contact tabs
                ..._extraAreas.map((id) {
                  return Row(
                    children: [
                      _AreaTabButton(
                        label: _extraAreaLabel(id),
                        isActive: _activeArea == id,
                        width: 260,
                        onTap: () => setState(() => _activeArea = id),
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
                          _extraAreas.add(_nextAreaId);
                          _activeArea = _nextAreaId;
                          _nextAreaId++;
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

                const SizedBox(height: 16, width: double.infinity),

                // ── Area form ─────────────────────────────────────────────────
                if (_activeArea == 0) MainAreaForums(),
              ],
            ),
          ),
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

//for the area buttons
class _AreaTabButton extends StatelessWidget {
  const _AreaTabButton({
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
