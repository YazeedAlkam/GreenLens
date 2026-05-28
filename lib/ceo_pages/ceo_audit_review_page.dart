import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/engineer_pages/ac_review.dart';
import 'package:greenlens/engineer_pages/equipment_review.dart';
import 'package:greenlens/engineer_pages/lighting_review.dart';
import 'package:greenlens/engineer_pages/production_review.dart';
// audit_data_entery_flow import removed — review bodies are embedded in IndexedStack
import 'package:greenlens/firebase/project_service.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/shared_files/custom_app_bar.dart';
import 'package:greenlens/shared_files/footer.dart';

class CeoAuditReviewPage extends StatefulWidget {
  final Map<String, dynamic> project;

  /// When true, approve/deny write to [sectionhead_approved] instead of [ceo_approved].
  final bool isSectionHead;

  const CeoAuditReviewPage({
    super.key,
    required this.project,
    this.isSectionHead = false,
  });

  @override
  State<CeoAuditReviewPage> createState() => _CeoAuditReviewPageState();
}

class _CeoAuditReviewPageState extends State<CeoAuditReviewPage> {
  final _projectService = ProjectService();
  bool _isProcessing = false;

  /// null = main view; 0 = Lighting, 1 = HVAC, 2 = Equipment, 3 = Machines
  int? _activeReview;

  // ── helpers ────────────────────────────────────────────────────────────────

  String _v(String? value) =>
      (value == null || value.trim().isEmpty) ? 'No Data' : value;

  Map<String, dynamic> get _proj =>
      widget.project['projectInfo'] as Map<String, dynamic>? ?? {};

  Map<String, dynamic> get _auditData =>
      widget.project['auditData'] as Map<String, dynamic>? ?? {};

  List<dynamic> get _lighting =>
      _auditData['lighting'] as List<dynamic>? ?? [];

  List<dynamic> get _ac => _auditData['ac'] as List<dynamic>? ?? [];

  List<dynamic> get _equipment =>
      _auditData['equipment'] as List<dynamic>? ?? [];

  List<dynamic> get _machines =>
      _auditData['machines'] as List<dynamic>? ?? [];

  // ── label builders (mirrors review_eng.dart logic) ─────────────────────────

  String _lightingLabel() {
    if (_lighting.isEmpty) return 'Not entered';
    final a = _lighting[0] as Map;
    final hasData =
        ['lightingType', 'ratedPower', 'numLights', 'yearlyHours']
            .any((k) => a[k]?.toString().isNotEmpty == true);
    if (_lighting.length == 1) return hasData ? '1 area' : 'Not entered';
    return '${_lighting.length} areas';
  }

  String _acLabel() {
    if (_ac.isEmpty) return 'Not entered';
    final g = _ac[0] as Map;
    final hasData = [
      'noOfUnits', 'capacity', 'yearlyHours', 'ratedPower',
      'noOfPackages', 'packageCapacity', 'packagePower',
      'chillerCapacity', 'chillerPower', 'chillerHours',
    ].any((k) => g[k]?.toString().isNotEmpty == true);
    if (_ac.length == 1) return hasData ? '1 group' : 'Not entered';
    return '${_ac.length} groups';
  }

  String _equipmentLabel() {
    if (_equipment.isEmpty) return 'Not entered';
    final filled = _equipment.where((e) {
      final m = e as Map;
      return ['name', 'ratedPower', 'quantity', 'yearlyHours']
          .any((k) => m[k]?.toString().trim().isNotEmpty == true);
    }).toList();
    if (filled.isEmpty) return 'Not entered';
    return '${filled.length} item${filled.length == 1 ? '' : 's'}';
  }

  String _machinesLabel() {
    if (_machines.isEmpty) return 'Not entered';
    final filled = _machines.where((e) {
      final m = e as Map;
      return ['name', 'ratedPower', 'quantity', 'yearlyHours']
          .any((k) => m[k]?.toString().trim().isNotEmpty == true);
    }).toList();
    if (filled.isEmpty) return 'Not entered';
    return '${filled.length} machine${filled.length == 1 ? '' : 's'}';
  }

  // ── total annual kWh (mirrors review_eng.dart logic) ──────────────────────

  double _totalEnergyCost() {
    double total = 0;

    for (final e in _lighting) {
      final m = e as Map;
      total += double.tryParse(m['energyCost']?.toString() ?? '') ?? 0;
    }

    for (final e in _ac) {
      final m = e as Map;
      final acType = m['acType'] as int? ?? 0;
      double kwh = 0;
      if (acType == 0) {
        final units = double.tryParse(m['noOfUnits']?.toString() ?? '') ?? 0;
        final power = double.tryParse(m['ratedPower']?.toString() ?? '') ?? 0;
        final hours = double.tryParse(m['yearlyHours']?.toString() ?? '') ?? 0;
        kwh = units * power * hours;
      } else if (acType == 1) {
        final units =
            double.tryParse(m['noOfPackages']?.toString() ?? '') ?? 0;
        final power =
            double.tryParse(m['packagePower']?.toString() ?? '') ?? 0;
        final hours =
            double.tryParse(m['packageHours']?.toString() ?? '') ?? 0;
        kwh = units * power * hours;
      } else if (acType == 2) {
        final power =
            double.tryParse(m['chillerPower']?.toString() ?? '') ?? 0;
        final hours =
            double.tryParse(m['chillerHours']?.toString() ?? '') ?? 0;
        kwh = power * hours;
      }
      total += kwh * energyTariffJodPerKwh;
    }

    for (final e in _equipment) {
      final m = e as Map;
      final power = double.tryParse(m['ratedPower']?.toString() ?? '') ?? 0;
      final qty = double.tryParse(m['quantity']?.toString() ?? '') ?? 0;
      final hours = double.tryParse(m['yearlyHours']?.toString() ?? '') ?? 0;
      total += power * qty * hours * energyTariffJodPerKwh;
    }

    for (final e in _machines) {
      final m = e as Map;
      final power = double.tryParse(m['ratedPower']?.toString() ?? '') ?? 0;
      final qty = double.tryParse(m['quantity']?.toString() ?? '') ?? 0;
      final hours = double.tryParse(m['yearlyHours']?.toString() ?? '') ?? 0;
      total += power * qty * hours * energyTariffJodPerKwh;
    }

    return total;
  }

  String _formatTotal() {
    final v = _totalEnergyCost();
    if (v == 0) return '—';
    return v == v.truncateToDouble()
        ? '${v.toInt()} JOD'
        : '${v.toStringAsFixed(2)} JOD';
  }

  // ── actions ────────────────────────────────────────────────────────────────

  Future<void> _acceptProject() async {
    setState(() => _isProcessing = true);

    final Map<String, dynamic> updates;

    if (widget.isSectionHead) {
      final ceoApproved =
          widget.project['ceo_approved'] as bool? ?? false;
      updates = {'sectionhead_approved': true};
      if (ceoApproved) updates['status'] = 'Ready';
    } else {
      final sectionHeadApproved =
          widget.project['sectionhead_approved'] as bool? ?? false;
      updates = {'ceo_approved': true};
      if (sectionHeadApproved) updates['status'] = 'Ready';
    }

    await _projectService.updateFields(
      widget.project['id'] as String,
      updates,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audit approved')),
      );
      Navigator.pop(context, true);
    }
  }

  Future<void> _denyProject() async {
    setState(() => _isProcessing = true);
    // Reset both flags so the next review cycle starts clean
    await _projectService.updateFields(
      widget.project['id'] as String,
      {
        'ceo_approved': false,
        'sectionhead_approved': false,
        'status': 'Denied',
      },
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audit denied')),
      );
      Navigator.pop(context, true);
    }
  }

  void _openLighting() => setState(() => _activeReview = 0);
  void _openHvac() => setState(() => _activeReview = 1);
  void _openEquipment() => setState(() => _activeReview = 2);
  void _openMachines() => setState(() => _activeReview = 3);
  void _closeReview() => setState(() => _activeReview = null);

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final projectName = _v(_proj['projectName'] as String?);
    final notes = (widget.project['auditNotes'] as String?) ??
        (_auditData['notes'] as String?) ??
        '';

    return Scaffold(
      appBar: CustomAppBar.build(
        title: 'Review $projectName',
        subtitle: 'Accept or Deny Project',
      ),
      body: IndexedStack(
        index: _activeReview != null ? _activeReview! + 1 : 0,
        children: [
          // ── index 0: main overview ──────────────────────────────────────
          Column(
            children: [
              Expanded(
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Colors.white, Colors.transparent],
                    stops: [0.0, 0.93, 1.0],
                  ).createShader(bounds),
                  blendMode: BlendMode.dstIn,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(32, 30, 32, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle('Building Info'),
                        const SizedBox(height: 16),
                        _buildingInfoCard(),
                        const SizedBox(height: 16),
                        _sectionTitle('Energy consumption breakdown'),
                        const SizedBox(height: 16),
                        _energyBreakdownCard(),
                        const SizedBox(height: 16),
                        _totalConsumptionCard(),
                        const SizedBox(height: 16),
                        _sectionTitle('Audit Notes'),
                        const SizedBox(height: 16),
                        _auditNotesBox(notes),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                child: _isProcessing
                    ? const Center(child: CircularProgressIndicator())
                    : Footer(
                        currentStep: 0,
                        onNext: () {},
                        onBack: () => Navigator.pop(context),
                        mode: FooterMode.acceptDeny,
                        onAccept: _acceptProject,
                        onDeny: _denyProject,
                      ),
              ),
            ],
          ),

          // ── index 1: Lighting review ────────────────────────────────────
          LightingReview(onBack: _closeReview, lightingData: _lighting),

          // ── index 2: AC / HVAC review ───────────────────────────────────
          AcReview(onBack: _closeReview, acData: _ac),

          // ── index 3: Equipment review ───────────────────────────────────
          EquipmentReview(onBack: _closeReview, equipmentData: _equipment),

          // ── index 4: Production / Machines review ───────────────────────
          ProductionReview(onBack: _closeReview, machinesData: _machines),
        ],
      ),
    );
  }

  // ── section helpers ────────────────────────────────────────────────────────

  Widget _sectionTitle(String text) => Text(
        text,
        style: GoogleFonts.firaSans(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
      );

  // Building Info card
  Widget _buildingInfoCard() {
    final avgBillRaw = (_proj['averageMonthlyBill'] as num?)?.toDouble() ?? 0;
    final avgBillDisplay = avgBillRaw > 0
        ? '${avgBillRaw == avgBillRaw.truncateToDouble() ? avgBillRaw.toInt() : avgBillRaw.toStringAsFixed(2)} JOD'
        : _v(null);

    final hrs = _proj['operatingHrsPerDay']?.toString() ?? '';
    final days = _proj['daysPerWeek']?.toString() ?? '';
    String opHours;
    if (hrs.isEmpty && days.isEmpty) {
      opHours = 'No Data';
    } else if (hrs.isEmpty) {
      opHours = '$days days/wk';
    } else if (days.isEmpty) {
      opHours = '$hrs hrs/day';
    } else {
      opHours = '$hrs hrs/day · $days days/wk';
    }

    final floorArea = _proj['floorArea']?.toString() ?? '';
    final floorAreaDisplay =
        floorArea.isEmpty ? 'No Data' : '$floorArea m²';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _buildingRow('Facility', _v(_proj['projectName'] as String?)),
          _divider(),
          _buildingRow('Type', _v(_proj['buildingType'] as String?)),
          _divider(),
          _buildingRow('Floor Area', floorAreaDisplay),
          _divider(),
          _buildingRow('Operating Hours', opHours),
          _divider(),
          _buildingRow(
            'Average Monthly Bill (Past 12 Months)',
            avgBillDisplay,
          ),
        ],
      ),
    );
  }

  Widget _buildingRow(String label, String value) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, thickness: 1, color: Color(0xFFA8A6A7));

  // Energy breakdown card
  Widget _energyBreakdownCard() {
    final sections = [
      ('Lighting', _lightingLabel(), _openLighting),
      ('HVAC', _acLabel(), _openHvac),
      ('Equipment', _equipmentLabel(), _openEquipment),
      ('Production Lines', _machinesLabel(), _openMachines),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            for (int i = 0; i < sections.length; i++) ...[
              _energyRow(sections[i].$1, sections[i].$2, sections[i].$3),
              if (i < sections.length - 1)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFA8A6A7),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _energyRow(String label, String statusLabel, VoidCallback onTap) {
    final hasData = statusLabel != 'Not entered';
    return InkWell(
      onTap: hasData ? onTap : null,
      child: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                children: [
                  Text(
                    statusLabel,
                    style: GoogleFonts.firaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: hasData ? Colors.black : Colors.grey,
                    ),
                  ),
                  if (hasData)
                    SvgPicture.asset(
                      'assets/images/arrowright.svg',
                      width: 40,
                      height: 40,
                      colorFilter: ColorFilter.mode(
                        primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Total annual consumption card
  Widget _totalConsumptionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Energy Cost',
            style: GoogleFonts.firaSans(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1A7A4A),
            ),
          ),
          Text(
            _formatTotal(),
            style: GoogleFonts.firaSans(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Audit notes
  Widget _auditNotesBox(String notes) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: tablelinescolor, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        notes.isEmpty ? 'Overall Observations...' : notes,
        style: GoogleFonts.firaSans(
          fontSize: 24,
          color: notes.isEmpty
              ? Colors.black.withValues(alpha: 0.5)
              : Colors.black,
        ),
      ),
    );
  }
}
