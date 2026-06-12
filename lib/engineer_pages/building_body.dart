import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';

import '../shared_files/footer.dart';

/// Step 1 of the audit entry wizard: general building information.
///
/// Displays read-only project info fields (name, type, area, floors, operating
/// hours, average bill, dates) and editable audit fields (visit date, sales
/// mark, notes). When [readOnly] is true all fields are disabled.
class BuildingBody extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final Map<String, dynamic>? projectInfo;
  final Map<String, dynamic>? auditBuildingData;
  final Future<void> Function()? onSaveDraft;
  final bool readOnly;
  const BuildingBody({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    this.projectInfo,
    this.auditBuildingData,
    this.onSaveDraft,
    this.readOnly = false,
  });

  @override
  State<BuildingBody> createState() => BuildingBodyState();
}

/// State for [BuildingBody]. Exposes [getBuildingAuditData] and [getSalesMark]
/// so the parent wizard can collect form data via a [GlobalKey].
class BuildingBodyState extends State<BuildingBody> {
  final TextEditingController visitdatecontroller = TextEditingController();
  final TextEditingController salesMarkController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  late final TextEditingController _projectNameCtrl = TextEditingController();
  late final TextEditingController _buildingTypeCtrl = TextEditingController();
  late final TextEditingController _floorAreaCtrl = TextEditingController();
  late final TextEditingController _noOfFloorsCtrl = TextEditingController();
  late final TextEditingController _operatingHrsCtrl = TextEditingController();
  late final TextEditingController _daysPerWeekCtrl = TextEditingController();
  late final TextEditingController _avgBillCtrl = TextEditingController();
  late final TextEditingController _initiationDateCtrl =
      TextEditingController();
  late final TextEditingController _deadlineDateCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _populateFromProjectInfo();
  }

  @override
  void didUpdateWidget(BuildingBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.projectInfo != widget.projectInfo) {
      _populateFromProjectInfo();
    }
  }

  /// Pre-fills all text controllers from [widget.projectInfo] and
  /// [widget.auditBuildingData] when the widget is first created or updated.
  void _populateFromProjectInfo() {
    final info = widget.projectInfo;
    if (info == null) return;
    _projectNameCtrl.text = info['projectName']?.toString() ?? '';
    _buildingTypeCtrl.text = info['buildingType']?.toString() ?? '';
    _floorAreaCtrl.text = info['floorArea']?.toString() ?? '';
    _noOfFloorsCtrl.text = info['noOfFloors']?.toString() ?? '';
    _operatingHrsCtrl.text = info['operatingHrsPerDay']?.toString() ?? '';
    _daysPerWeekCtrl.text = info['daysPerWeek']?.toString() ?? '';
    final avg = info['averageMonthlyBill'];
    _avgBillCtrl.text = avg != null ? avg.toString() : '';
    _initiationDateCtrl.text = info['initiationDate']?.toString() ?? '';
    _deadlineDateCtrl.text = info['deadlineDate']?.toString() ?? '';
    salesMarkController.text = info['salesMark']?.toString() ?? '';

    final audit = widget.auditBuildingData;
    if (audit != null) {
      visitdatecontroller.text = audit['visitDate']?.toString() ?? '';
      notesController.text = audit['notes']?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    visitdatecontroller.dispose();
    salesMarkController.dispose();
    notesController.dispose();
    _projectNameCtrl.dispose();
    _buildingTypeCtrl.dispose();
    _floorAreaCtrl.dispose();
    _noOfFloorsCtrl.dispose();
    _operatingHrsCtrl.dispose();
    _daysPerWeekCtrl.dispose();
    _avgBillCtrl.dispose();
    _initiationDateCtrl.dispose();
    _deadlineDateCtrl.dispose();
    super.dispose();
  }

  /// Returns a map with audit-specific fields (visit date, notes)
  /// to be stored under `auditData.building` in Firestore.
  Map<String, dynamic> getBuildingAuditData() => {
    'visitDate': visitdatecontroller.text,
    'notes': notesController.text,
  };

  /// Returns the sales-mark string entered by the engineer.
  String getSalesMark() => salesMarkController.text;

  /// Shows a [showDatePicker] dialog and writes the selected date as
  /// "d/M/yyyy" into [controller].
  Future<void> pickDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  InputDecoration _readOnlyDecoration({String? suffix}) {
    return InputDecoration(
      filled: true,
      fillColor: disableColor,
      hoverColor: disableColor,
      hintText: "No Data",
      hintStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xFF808080),
      ),
      suffixText: suffix,
      suffixStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Color(0xFF808080),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 2, color: Color(0xFF808080)),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 2, color: Color(0xFF808080)),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  /// Greyed-out, non-editable field showing data carried over from the
  /// project info entered by the Section Head.
  Widget _readOnlyField(TextEditingController ctrl, {String? suffix}) {
    return SizedBox(
      height: 65,
      child: TextField(
        controller: ctrl,
        readOnly: true,
        expands: true,
        maxLines: null,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        decoration: _readOnlyDecoration(suffix: suffix),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 30),
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
                "Building & facility info",
                style: GoogleFonts.firaSans(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const Divider(color: dividerColor),
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
          _readOnlyField(_projectNameCtrl),
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
              const SizedBox(width: 20),
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
              Expanded(child: _readOnlyField(_buildingTypeCtrl)),
              const SizedBox(width: 16),
              Expanded(child: _readOnlyField(_floorAreaCtrl)),
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
              const SizedBox(width: 20),
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
              Expanded(child: _readOnlyField(_noOfFloorsCtrl)),
              const SizedBox(width: 16),
              Expanded(child: _readOnlyField(_operatingHrsCtrl)),
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
              const SizedBox(width: 20),
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
              Expanded(child: _readOnlyField(_daysPerWeekCtrl)),
              const SizedBox(width: 16),
              Expanded(child: _readOnlyField(_avgBillCtrl, suffix: 'JOD')),
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
              const SizedBox(width: 20),
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
              Expanded(child: _readOnlyField(_initiationDateCtrl)),
              const SizedBox(width: 16),
              Expanded(child: _readOnlyField(_deadlineDateCtrl)),
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
              controller: salesMarkController,
              readOnly: widget.readOnly,
              maxLines: 4,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: "Short Description about Sales Mark",
                hintStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF808080),
                ),
                filled: widget.readOnly,
                fillColor: disableColor,
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Visit Date ---------------->
          Row(
            children: [
              Text(
                "Visit Date",
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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: "e.g 26th of June, 2026 ",
                hintStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF808080),
                ),
                filled: widget.readOnly,
                fillColor: disableColor,
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              controller: visitdatecontroller,
              readOnly: true,
              onTap: widget.readOnly ? null : () => pickDate(visitdatecontroller),
            ),
          ),
          const SizedBox(height: 10),
          //nots row
          Row(
            children: [
              Text(
                "Notes / Observations",
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
              controller: notesController,
              readOnly: widget.readOnly,
              maxLines: 4,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: "Any observations during site visit...",
                hintStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF808080),
                ),
                filled: widget.readOnly,
                fillColor: disableColor,
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // ── Footer ───────────────────────────────────────────────────────
          Footer(
            currentStep: widget.currentStep,
            onNext: widget.onNext,
            onBack: widget.onBack,
            mode: widget.readOnly ? FooterMode.viewOnly : FooterMode.auditNormal,
            onSaveDraft: widget.onSaveDraft,
          ),
          const SizedBox(height: 6000),
        ],
      ),
    );
  }
}
