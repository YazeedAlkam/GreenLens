import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/shared_files/footer.dart';

class ReviewBodyEng extends StatefulWidget {
  final VoidCallback onBack;
  final int currentStep;
  final Future<void> Function() onSave;
  final Map<String, dynamic>? projectInfo;
  final List<dynamic> lightingData;
  final List<dynamic> acData;
  final List<dynamic> equipmentData;
  final List<dynamic> machinesData;
  final VoidCallback? onViewLighting;
  final VoidCallback? onViewAC;
  final VoidCallback? onViewEquipment;
  final VoidCallback? onViewMachines;
  final bool readOnly;

  const ReviewBodyEng({
    super.key,
    required this.onBack,
    required this.currentStep,
    required this.onSave,
    this.projectInfo,
    this.lightingData = const [],
    this.acData = const [],
    this.equipmentData = const [],
    this.machinesData = const [],
    this.onViewLighting,
    this.onViewAC,
    this.onViewEquipment,
    this.onViewMachines,
    this.readOnly = false,
  });

  @override
  State<ReviewBodyEng> createState() => _ReviewBodyEngState();
}

class _ReviewBodyEngState extends State<ReviewBodyEng> {
  String _v(String? value) =>
      (value == null || value.trim().isEmpty) ? 'No Data' : value;

  String _operatingHours() {
    final hrs = widget.projectInfo?['operatingHrsPerDay']?.toString() ?? '';
    final days = widget.projectInfo?['daysPerWeek']?.toString() ?? '';
    if (hrs.isEmpty && days.isEmpty) return 'No Data';
    if (hrs.isEmpty) return '$days days/wk';
    if (days.isEmpty) return '$hrs hrs/day';
    return '$hrs hrs/day · $days days/wk';
  }

  String _avgBill() {
    final bill = widget.projectInfo?['averageMonthlyBill']?.toString() ?? '';
    return bill.isEmpty ? 'No Data' : '$bill JOD';
  }

  // Lighting: Area 1 always exists — if 2+ areas, user explicitly added them.
  // For a single area, check if any field is filled.
  String _lightingLabel() {
    final data = widget.lightingData;
    if (data.isEmpty) return 'Not entered';
    final a = data[0] as Map;
    final hasData = ['lightingType', 'ratedPower', 'numLights', 'yearlyHours']
        .any((k) => a[k]?.toString().isNotEmpty == true);
    if (data.length == 1) return hasData ? '1 area' : 'Not entered';
    return '${data.length} areas';
  }

  // AC: Group 1 always exists — if 2+ groups, user explicitly added them.
  // For a single group, check any field across all AC types (Split/Packaged/Central).
  String _acLabel() {
    final data = widget.acData;
    if (data.isEmpty) return 'Not entered';
    final g = data[0] as Map;
    final hasData = [
      'noOfUnits', 'capacity', 'yearlyHours', 'ratedPower',
      'noOfPackages', 'packageCapacity', 'packagePower',
      'chillerCapacity', 'chillerPower', 'chillerHours',
    ].any((k) => g[k]?.toString().isNotEmpty == true);
    if (data.length == 1) return hasData ? '1 group' : 'Not entered';
    return '${data.length} groups';
  }

  double _totalEnergyCost() {
    double total = 0;

    // Lighting: 'energyCost' is pre-computed (JD) and stored in the map
    for (final e in widget.lightingData) {
      final map = e as Map;
      total += double.tryParse(map['energyCost']?.toString() ?? '') ?? 0;
    }

    // AC: compute based on acType (not stored in toMap)
    for (final e in widget.acData) {
      final map = e as Map;
      final acType = map['acType'] as int? ?? 0;
      double kwh = 0;
      if (acType == 0) {
        final units = double.tryParse(map['noOfUnits']?.toString() ?? '') ?? 0;
        final power = double.tryParse(map['ratedPower']?.toString() ?? '') ?? 0;
        final hours = double.tryParse(map['yearlyHours']?.toString() ?? '') ?? 0;
        kwh = units * power * hours;
      } else if (acType == 1) {
        final units = double.tryParse(map['noOfPackages']?.toString() ?? '') ?? 0;
        final power = double.tryParse(map['packagePower']?.toString() ?? '') ?? 0;
        final hours = double.tryParse(map['packageHours']?.toString() ?? '') ?? 0;
        kwh = units * power * hours;
      } else if (acType == 2) {
        final power = double.tryParse(map['chillerPower']?.toString() ?? '') ?? 0;
        final hours = double.tryParse(map['chillerHours']?.toString() ?? '') ?? 0;
        kwh = power * hours;
      }
      total += kwh * energyTariffJodPerKwh;
    }

    for (final e in widget.equipmentData) {
      final map = e as Map;
      final power = double.tryParse(map['ratedPower']?.toString() ?? '') ?? 0;
      final qty   = double.tryParse(map['quantity']?.toString() ?? '') ?? 0;
      final hours = double.tryParse(map['yearlyHours']?.toString() ?? '') ?? 0;
      total += power * qty * hours * energyTariffJodPerKwh;
    }

    for (final e in widget.machinesData) {
      final map = e as Map;
      final power = double.tryParse(map['ratedPower']?.toString() ?? '') ?? 0;
      final qty   = double.tryParse(map['quantity']?.toString() ?? '') ?? 0;
      final hours = double.tryParse(map['yearlyHours']?.toString() ?? '') ?? 0;
      total += power * qty * hours * energyTariffJodPerKwh;
    }

    return total;
  }

  String _formatTotal(double value) {
    if (value == 0) return '—';
    if (value == value.truncateToDouble()) {
      return '${value.toInt()} JOD';
    }
    return '${value.toStringAsFixed(2)} JOD';
  }

  String _countLabel(List<dynamic> list, String unit) {
    if (list.isEmpty) return 'Not entered';
    return '${list.length} $unit${list.length == 1 ? '' : 's'}';
  }

  Widget _infoRow(String label, String value) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            Text(
              value,
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
  }

  Widget _sectionRow(String title, {required String label, required bool dividerBelow, VoidCallback? onTap}) {
    final isEntered = label != 'Not entered';
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Text(
                  title,
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                Text(
                  label,
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: isEntered ? Colors.black : Colors.grey,
                  ),
                ),
                SvgPicture.asset('assets/images/arrowright.svg', colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),),
              ],
            ),
          ),
        ),
        if (dividerBelow)
          const Divider(color: Color(0xFFA8A6A7), thickness: 1, height: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 30, 32, 0),
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────────────
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
                Text(
                  ' Review & Submit',
                  style: GoogleFonts.firaSans(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const Divider(color: dividerColor),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Building Info",
                  style: GoogleFonts.firaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // ── Building Info Table ─────────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  _infoRow("Project Name", _v(widget.projectInfo?['projectName'] as String?)),
                  const Divider(color: Color(0xFFA8A6A7), thickness: 1, height: 1),
                  _infoRow("Type", _v(widget.projectInfo?['buildingType'] as String?)),
                  const Divider(color: Color(0xFFA8A6A7), thickness: 1, height: 1),
                  _infoRow("Floor Area", widget.projectInfo?['floorArea']?.toString().isNotEmpty == true ? '${widget.projectInfo!['floorArea']} m²' : 'No Data'),
                  const Divider(color: Color(0xFFA8A6A7), thickness: 1, height: 1),
                  _infoRow("Operating Hours", _operatingHours()),
                  const Divider(color: Color(0xFFA8A6A7), thickness: 1, height: 1),
                  _infoRow("Average Monthly Bill (Past 12 Months)", _avgBill()),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  "Energy Consumption Breakdown",
                  style: GoogleFonts.firaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            //Energy consumption breakdown Table ----------->
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  _sectionRow("Lighting", label: _lightingLabel(), dividerBelow: true, onTap: widget.onViewLighting),
                  _sectionRow("AC", label: _acLabel(), dividerBelow: true, onTap: widget.onViewAC),
                  _sectionRow("Equipment", label: _countLabel(widget.equipmentData, 'item'), dividerBelow: true, onTap: widget.onViewEquipment),
                  _sectionRow("Production Lines", label: _countLabel(widget.machinesData, 'line'), dividerBelow: false, onTap: widget.onViewMachines),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Energy Cost",
                    style: GoogleFonts.firaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF1A7A4A),
                    ),
                  ),
                  Text(
                    _formatTotal(_totalEnergyCost()),
                    style: GoogleFonts.firaSans(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Footer(
              currentStep: widget.currentStep,
              onNext: widget.onSave,
              onBack: widget.onBack,
              mode: widget.readOnly ? FooterMode.done : FooterMode.submitReview,
              onSaveProject: widget.onSave,
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
