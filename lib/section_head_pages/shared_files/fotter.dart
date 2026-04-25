import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';

class CreateNewProjectFooter extends StatelessWidget {
  final int currentStep;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const CreateNewProjectFooter({
    super.key,
    required this.currentStep,
    required this.onNext,
    required this.onBack,
  });

  // TODO: implement save draft logic
  void _saveDraft() {}

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ── Back ─────────────────────────────────────────────────────────
        SizedBox(
          width: 183,
          height: 65,
          child: ElevatedButton(
            onPressed: onBack,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                const SizedBox(width: 10),
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

        // ── Save Draft ───────────────────────────────────────────────────
        SizedBox(
          width: 309,
          height: 65,
          child: ElevatedButton(
            onPressed: _saveDraft,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: Colors.black, width: 1.5),
              ),
            ),
            child: Text(
              "Save Draft",
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ),

        const SizedBox(width: 17),

        // ── Next Step ────────────────────────────────────────────────────
        SizedBox(
          width: 434,
          height: 65,
          child: ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                const SizedBox(width: 10),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.diagonal3Values(-1.0, 1.0, 1.0),
                  child: SvgPicture.asset(
                    'assets/images/Left Arrow.svg',
                    width: 40,
                    height: 40,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
