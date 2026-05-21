import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';

enum FooterMode {
  /// Back + Save Draft + Next Step  (steps 0–3)
  normal,
  /// Back + Save Project            (step 4 – Review)
  review,
  /// Back only                      (Bills / All Contacts sub-pages)
  backOnly,
  /// Back + Next only               (read-only view mode)
  viewOnly,
  /// Back + Done                    (read-only review/last step)
  done,
  /// Back + Save + Next Step        (audit data entry steps)
  auditNormal,
  /// Back + Submit for Review       (engineer review/last step)
  submitReview,
  /// Back + Accept Project + Deny Project  (CEO approval flow)
  acceptDeny,
}

class Footer extends StatelessWidget {
  final int currentStep;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final FooterMode mode;
  final Future<void> Function()? onSaveDraft;
  final Future<void> Function()? onSaveProject;
  final Future<void> Function()? onAccept;
  final Future<void> Function()? onDeny;

  const Footer({
    super.key,
    required this.currentStep,
    required this.onNext,
    required this.onBack,
    this.mode = FooterMode.normal,
    this.onSaveDraft,
    this.onSaveProject,
    this.onAccept,
    this.onDeny,
  });

  // ── shared button styles ────────────────────────────────────────────────

  ButtonStyle get _outlineStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: const BorderSide(color: Colors.black, width: 1.5),
    ),
  );

  ButtonStyle get _primaryStyle => ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: const BorderSide(color: Colors.black, width: 1.5),
    ),
  );

  ButtonStyle get _saveStyle => ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF2e7d32),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
  );

  // ── reusable widgets ────────────────────────────────────────────────────

  Widget _backButton() => SizedBox(
    width: double.infinity,
    height: 65,
    child: ElevatedButton(
      onPressed: onBack,
      style: _outlineStyle,
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
  );

  Widget _backButtonCompact() => SizedBox(
    height: 65,
    child: ElevatedButton(
      onPressed: onBack,
      style: _outlineStyle,
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
  );

  Widget _saveDraftButton() => SizedBox(
    width: 309,
    height: 65,
    child: ElevatedButton(
      onPressed: onSaveDraft,
      style: _outlineStyle,
      child: Text(
        "Save Draft",
        style: GoogleFonts.firaSans(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    ),
  );

  Widget _saveButton() => SizedBox(
    width: 309,
    height: 65,
    child: ElevatedButton(
      onPressed: onSaveDraft,
      style: _outlineStyle,
      child: Text(
        "Save",
        style: GoogleFonts.firaSans(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    ),
  );

  Widget _nextStepButton() => SizedBox(
    width: double.infinity,
    height: 65,
    child: ElevatedButton(
      onPressed: onNext,
      style: _primaryStyle,
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
  );

  Widget _doneButton() => SizedBox(
    width: double.infinity,
    height: 65,
    child: ElevatedButton(
      onPressed: onNext,
      style: _primaryStyle,
      child: Text(
        "Done",
        style: GoogleFonts.firaSans(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    ),
  );

  Widget _submitForReviewButton() => SizedBox(
    width: 760,
    height: 65,
    child: ElevatedButton(
      onPressed: onSaveProject,
      style: _saveStyle,
      child: Text(
        "Submit for Review",
        style: GoogleFonts.firaSans(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    ),
  );

  Widget _saveProjectButton() => SizedBox(
    width: 760,
    height: 65,
    child: ElevatedButton(
      onPressed: onSaveProject,
      style: _saveStyle,
      child: Text(
        "Save Project",
        style: GoogleFonts.firaSans(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    ),
  );

  Widget _acceptButton() => SizedBox(
    height: 65,
    child: ElevatedButton(
      onPressed: onAccept,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: Text(
        "Accept Project",
        style: GoogleFonts.firaSans(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    ),
  );

  Widget _denyButton() => SizedBox(
    height: 65,
    child: ElevatedButton(
      onPressed: onDeny,
      style: ElevatedButton.styleFrom(
        backgroundColor: deniedColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: Text(
        "Deny Project",
        style: GoogleFonts.firaSans(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      // ── Back only ──────────────────────────────────────────────────────
      case FooterMode.backOnly:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Expanded(child: _backButton())],
        );

      // ── Review: Back + Save Project ────────────────────────────────────
      case FooterMode.review:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _backButton()),
            const SizedBox(width: 17),
            _saveProjectButton(),
          ],
        );

      // ── Normal: Back + Save Draft + Next Step ──────────────────────────
      case FooterMode.normal:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _backButton()),
            const SizedBox(width: 17),
            _saveDraftButton(),
            const SizedBox(width: 17),
            Expanded(child: _nextStepButton()),
          ],
        );

      // ── Audit Normal: Back + Save + Next Step ─────────────────────────
      case FooterMode.auditNormal:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _backButton()),
            const SizedBox(width: 17),
            _saveButton(),
            const SizedBox(width: 17),
            Expanded(child: _nextStepButton()),
          ],
        );

      // ── View Only: Back + Next (no save) ───────────────────────────────
      case FooterMode.viewOnly:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _backButton()),
            const SizedBox(width: 17),
            Expanded(child: _nextStepButton()),
          ],
        );

      // ── Done: Back + Done ──────────────────────────────────────────────
      case FooterMode.done:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _backButton()),
            const SizedBox(width: 17),
            Expanded(child: _doneButton()),
          ],
        );

      // ── Submit Review: Back + Submit for Review ────────────────────────
      case FooterMode.submitReview:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _backButton()),
            const SizedBox(width: 17),
            _submitForReviewButton(),
          ],
        );

      // ── Accept/Deny: Back + Accept Project + Deny Project ─────────────
      case FooterMode.acceptDeny:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _backButtonCompact(),
            const SizedBox(width: 17),
            Expanded(child: _acceptButton()),
            const SizedBox(width: 17),
            Expanded(child: _denyButton()),
          ],
        );
    }
  }
}
