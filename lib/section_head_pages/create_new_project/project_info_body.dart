import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/shared_files/fotter.dart';

class ProjectInfoBody extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final VoidCallback onViewBills;
  final Future<void> Function()? onSaveDraft;
  final Map<String, dynamic>? initialProjectInfo;
  final bool readOnly;

  const ProjectInfoBody({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    required this.onViewBills,
    required this.onSaveDraft,
    this.initialProjectInfo,
    this.readOnly = false,
  });

  @override
  State<ProjectInfoBody> createState() => ProjectInfoBodyState();
}

class ProjectInfoBodyState extends State<ProjectInfoBody>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _projectNameCtrl = TextEditingController();
  final _buildingTypeCtrl = TextEditingController();
  final _floorAreaCtrl = TextEditingController();
  final _noOfFloorsCtrl = TextEditingController();
  final _operatingHrsCtrl = TextEditingController();
  final _daysPerWeekCtrl = TextEditingController();
  final _initiationDateCtrl = TextEditingController();
  final _deadlineDateCtrl = TextEditingController();
  final _salesMarkCtrl = TextEditingController();
  final _avgMonthlyBillCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final data = widget.initialProjectInfo;
    if (data == null) return;
    _projectNameCtrl.text = data['projectName'] ?? '';
    _buildingTypeCtrl.text = data['buildingType'] ?? '';
    _floorAreaCtrl.text = data['floorArea'] ?? '';
    _noOfFloorsCtrl.text = data['noOfFloors'] ?? '';
    _operatingHrsCtrl.text = data['operatingHrsPerDay'] ?? '';
    _daysPerWeekCtrl.text = data['daysPerWeek'] ?? '';
    _initiationDateCtrl.text = data['initiationDate'] ?? '';
    _deadlineDateCtrl.text = data['deadlineDate'] ?? '';
    _salesMarkCtrl.text = data['salesMark'] ?? '';
    final avg = data['averageBill'];
    if (avg != null) _avgMonthlyBillCtrl.text = avg.toString();
  }

  @override
  void dispose() {
    _projectNameCtrl.dispose();
    _buildingTypeCtrl.dispose();
    _floorAreaCtrl.dispose();
    _noOfFloorsCtrl.dispose();
    _operatingHrsCtrl.dispose();
    _daysPerWeekCtrl.dispose();
    _initiationDateCtrl.dispose();
    _deadlineDateCtrl.dispose();
    _salesMarkCtrl.dispose();
    _avgMonthlyBillCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
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

  void updateAverageBill(double avg) {
    setState(() {
      _avgMonthlyBillCtrl.text = avg > 0 ? avg.toStringAsFixed(2) : '';
    });
  }

  Map<String, dynamic> getProjectInfo() {
    return {
      'projectName': _projectNameCtrl.text,
      'buildingType': _buildingTypeCtrl.text,
      'floorArea': _floorAreaCtrl.text,
      'noOfFloors': _noOfFloorsCtrl.text,
      'operatingHrsPerDay': _operatingHrsCtrl.text,
      'daysPerWeek': _daysPerWeekCtrl.text,
      'initiationDate': _initiationDateCtrl.text,
      'deadlineDate': _deadlineDateCtrl.text,
      'salesMark': _salesMarkCtrl.text,
    };
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
              controller: _projectNameCtrl,
              readOnly: widget.readOnly,
              expands: true,
              maxLines: null,
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: "e.g Commercial",
                hintStyle: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF808080),
                ),
                filled: widget.readOnly,
                fillColor: disableColor,
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
              const SizedBox(height: 20),
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
                    controller: _buildingTypeCtrl,
                    readOnly: widget.readOnly,
                    expands: true,
                    maxLines: null,
                    style: GoogleFonts.firaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: "e.g Commercial",
                      hintStyle: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF808080),
                      ),
                      filled: widget.readOnly,
                      fillColor: disableColor,
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
                    controller: _floorAreaCtrl,
                    readOnly: widget.readOnly,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    expands: true,
                    maxLines: null,
                    style: GoogleFonts.firaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: "e.g 5000",
                      hintStyle: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF808080),
                      ),
                      filled: widget.readOnly,
                      fillColor: disableColor,
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
              const SizedBox(height: 20),
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
                    controller: _noOfFloorsCtrl,
                    readOnly: widget.readOnly,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    expands: true,
                    maxLines: null,
                    style: GoogleFonts.firaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: "e.g 4",
                      hintStyle: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF808080),
                      ),
                      filled: widget.readOnly,
                      fillColor: disableColor,
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
                    controller: _operatingHrsCtrl,
                    readOnly: widget.readOnly,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    expands: true,
                    maxLines: null,
                    style: GoogleFonts.firaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: "e.g 12",
                      hintStyle: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF808080),
                      ),
                      filled: widget.readOnly,
                      fillColor: disableColor,
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
              const SizedBox(height: 20),
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
                    controller: _daysPerWeekCtrl,
                    readOnly: widget.readOnly,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    expands: true,
                    maxLines: null,
                    style: GoogleFonts.firaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: "e.g 6",
                      hintStyle: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF808080),
                      ),
                      filled: widget.readOnly,
                      fillColor: disableColor,
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
                    controller: _avgMonthlyBillCtrl,
                    readOnly: true,
                    expands: true,
                    maxLines: null,
                    style: GoogleFonts.firaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
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
                      suffixText: 'JOD',
                      suffixStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF808080),
                      ),
                      suffixIcon: widget.readOnly ? null : Padding(
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
              const SizedBox(height: 20),
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
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: "e.g 26th of June, 2026 ",
                      hintStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF808080),
                      ),
                      filled: widget.readOnly,
                      fillColor: disableColor,
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
                    controller: _initiationDateCtrl,
                    readOnly: true,
                    onTap: widget.readOnly ? null : () => _pickDate(_initiationDateCtrl),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 65,
                  child: TextField(
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: "e.g 26th of June, 2026 ",
                      hintStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF808080),
                      ),
                      filled: widget.readOnly,
                      fillColor: disableColor,
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
                    controller: _deadlineDateCtrl,
                    readOnly: true,
                    onTap: widget.readOnly ? null : () => _pickDate(_deadlineDateCtrl),
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
              controller: _salesMarkCtrl,
              readOnly: widget.readOnly,
              maxLines: 4,
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: "Short Description about Sales Mark",
                hintStyle: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF808080),
                ),
                filled: widget.readOnly,
                fillColor: disableColor,
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
            onSaveDraft: widget.onSaveDraft,
            mode: widget.readOnly ? FooterMode.viewOnly : FooterMode.normal,
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
