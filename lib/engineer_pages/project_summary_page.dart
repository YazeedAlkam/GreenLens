import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/engineer_pages/ac_review.dart';
import 'package:greenlens/engineer_pages/equipment_review.dart';
import 'package:greenlens/engineer_pages/lighting_review.dart';
import 'package:greenlens/engineer_pages/production_review.dart';
import 'package:greenlens/firebase/project_service.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/section_head_pages/create_new_project/all_contacts_body.dart';
import 'package:greenlens/shared_files/charts/project_charts_grid.dart';
import 'package:greenlens/shared_files/custom_app_bar.dart';
import 'package:greenlens/shared_files/footer.dart';

class ProjectSummaryPage extends StatefulWidget {
  final String projectId;
  final String projectName;

  const ProjectSummaryPage({
    super.key,
    required this.projectId,
    required this.projectName,
  });

  @override
  State<ProjectSummaryPage> createState() => _ProjectSummaryPageState();
}

class _ProjectSummaryPageState extends State<ProjectSummaryPage> {
  final _projectService = ProjectService();
  Map<String, dynamic>? _project;
  List<Map<String, dynamic>> _engineers = [];
  bool _loading = true;

  /// null = main; 0 = contacts, 1 = lighting, 2 = AC, 3 = equipment, 4 = machines
  int? _activeSection;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final project = await _projectService.getProjectById(widget.projectId);
    if (project == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    final assignedIds =
        List<String>.from(project['assignedEngineers'] as List? ?? []);
    List<Map<String, dynamic>> engineers = [];
    if (assignedIds.isNotEmpty) {
      final all = await _projectService.getEngineers();
      engineers =
          all.where((e) => assignedIds.contains(e['id'] as String)).toList();
    }
    if (mounted) {
      setState(() {
        _project = project;
        _engineers = engineers;
        _loading = false;
      });
    }
  }

  // ── data accessors ─────────────────────────────────────────────────────────

  Map<String, dynamic> get _proj =>
      _project?['projectInfo'] as Map<String, dynamic>? ?? {};

  Map<String, dynamic> get _clientInfo =>
      _project?['clientInfo'] as Map<String, dynamic>? ?? {};

  Map<String, dynamic> get _main =>
      _clientInfo['mainContact'] as Map<String, dynamic>? ?? {};

  Map<String, dynamic> get _costs =>
      _project?['costs'] as Map<String, dynamic>? ?? {};

  Map<String, dynamic> get _auditData =>
      _project?['auditData'] as Map<String, dynamic>? ?? {};

  List<dynamic> get _lighting => _auditData['lighting'] as List<dynamic>? ?? [];
  List<dynamic> get _ac => _auditData['ac'] as List<dynamic>? ?? [];
  List<dynamic> get _equipment =>
      _auditData['equipment'] as List<dynamic>? ?? [];
  List<dynamic> get _machines => _auditData['machines'] as List<dynamic>? ?? [];

  // ── section navigation ─────────────────────────────────────────────────────

  void _openContacts() => setState(() => _activeSection = 0);
  void _openLighting() => setState(() => _activeSection = 1);
  void _openHvac() => setState(() => _activeSection = 2);
  void _openEquipment() => setState(() => _activeSection = 3);
  void _openMachines() => setState(() => _activeSection = 4);
  void _closeSection() => setState(() => _activeSection = null);

  // ── helpers ────────────────────────────────────────────────────────────────

  String _v(String? value) =>
      (value == null || value.trim().isEmpty) ? 'No Data' : value;

  String _operatingHours() {
    final hrs = _proj['operatingHrsPerDay']?.toString() ?? '';
    final days = _proj['daysPerWeek']?.toString() ?? '';
    if (hrs.isEmpty && days.isEmpty) return 'No Data';
    if (hrs.isEmpty) return '$days days/wk';
    if (days.isEmpty) return '$hrs hrs/day';
    return '$hrs hrs/day · $days days/wk';
  }

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
        kwh = (double.tryParse(m['noOfUnits']?.toString() ?? '') ?? 0) *
            (double.tryParse(m['ratedPower']?.toString() ?? '') ?? 0) *
            (double.tryParse(m['yearlyHours']?.toString() ?? '') ?? 0);
      } else if (acType == 1) {
        kwh = (double.tryParse(m['noOfPackages']?.toString() ?? '') ?? 0) *
            (double.tryParse(m['packagePower']?.toString() ?? '') ?? 0) *
            (double.tryParse(m['packageHours']?.toString() ?? '') ?? 0);
      } else if (acType == 2) {
        kwh = (double.tryParse(m['chillerPower']?.toString() ?? '') ?? 0) *
            (double.tryParse(m['chillerHours']?.toString() ?? '') ?? 0);
      }
      total += kwh * energyTariffJodPerKwh;
    }
    for (final e in _equipment) {
      final m = e as Map;
      total += (double.tryParse(m['ratedPower']?.toString() ?? '') ?? 0) *
          (double.tryParse(m['quantity']?.toString() ?? '') ?? 0) *
          (double.tryParse(m['yearlyHours']?.toString() ?? '') ?? 0) *
          energyTariffJodPerKwh;
    }
    for (final e in _machines) {
      final m = e as Map;
      total += (double.tryParse(m['ratedPower']?.toString() ?? '') ?? 0) *
          (double.tryParse(m['quantity']?.toString() ?? '') ?? 0) *
          (double.tryParse(m['yearlyHours']?.toString() ?? '') ?? 0) *
          energyTariffJodPerKwh;
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

  String _engineerCostDisplay() {
    final start = _parseDate(_proj['initiationDate'] as String?);
    final end = _parseDate(_proj['deadlineDate'] as String?);
    if (start == null || end == null || end.isBefore(start)) return 'No Data';
    final days = _workingDaysBetween(start, end);
    double total = 0;
    for (final eng in _engineers) {
      total += ((eng['rate'] as num?)?.toDouble() ?? 0) * 8 * days;
    }
    if (total == 0) return 'No Data';
    final formatted = total == total.truncateToDouble()
        ? total.toInt().toString()
        : total.toStringAsFixed(2);
    return '$formatted JOD';
  }

  DateTime? _parseDate(String? s) {
    if (s == null || s.trim().isEmpty) return null;
    final parts = s.split('/');
    if (parts.length != 3) return null;
    final d = int.tryParse(parts[0]);
    final mo = int.tryParse(parts[1]);
    final y = int.tryParse(parts[2]);
    if (d == null || mo == null || y == null) return null;
    return DateTime(y, mo, d);
  }

  int _workingDaysBetween(DateTime start, DateTime end) {
    int count = 0;
    DateTime cur = DateTime(start.year, start.month, start.day);
    final last = DateTime(end.year, end.month, end.day);
    while (!cur.isAfter(last)) {
      if (cur.weekday != DateTime.friday && cur.weekday != DateTime.saturday) {
        count++;
      }
      cur = cur.add(const Duration(days: 1));
    }
    return count;
  }

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: CustomAppBar.build(
          title: 'Project Summary',
          subtitle: 'Manage and audit your project',
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_project == null) {
      return Scaffold(
        appBar: CustomAppBar.build(
          title: 'Project Summary',
          subtitle: 'Manage and audit your project',
        ),
        body: Center(
          child: Text('Project not found.',
              style: GoogleFonts.firaSans(fontSize: 18)),
        ),
      );
    }

    final customId = _project!['customId'] as String? ?? '';
    final notes = (_project!['auditNotes'] as String?) ?? '';

    return Scaffold(
      appBar: CustomAppBar.build(
        title: 'Project Summary',
        subtitle: 'Manage and audit your project',
      ),
      body: IndexedStack(
        index: _activeSection != null ? _activeSection! + 1 : 0,
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
                        // ── back + heading ────────────────────────────
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: SvgPicture.asset(
                                'assets/images/Left Arrow.svg',
                                height: 32,
                                width: 32,
                                colorFilter: const ColorFilter.mode(
                                    Colors.black, BlendMode.srcIn),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Overview',
                              style: GoogleFonts.firaSans(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: dividerColor),
                        const SizedBox(height: 8),

                        // ── charts ────────────────────────────────────
                        ProjectChartsGrid(projectId: widget.projectId),
                        const SizedBox(height: 24),

                        // ── Client Info ───────────────────────────────
                        _sectionTitle('Client Info'),
                        const SizedBox(height: 12),
                        _card([
                          _row('ID', _v(customId)),
                          _row('Full Name', _v(_main['name'] as String?)),
                          _row('Client Position',
                              _v(_main['position'] as String?)),
                          _row('Client Email', _v(_main['email'] as String?)),
                          _row('Client Phone Number',
                              _v(_main['phone'] as String?)),
                          _viewAllContactsRow(),
                        ]),
                        const SizedBox(height: 24),

                        // ── Building Info ─────────────────────────────
                        _sectionTitle('Building Info'),
                        const SizedBox(height: 12),
                        _card([
                          _row('Facility',
                              _v(_proj['projectName'] as String?)),
                          _row('Type',
                              _v(_proj['buildingType'] as String?)),
                          _row(
                            'Floor Area',
                            _proj['floorArea']?.toString().isNotEmpty == true
                                ? '${_proj['floorArea']} m²'
                                : 'No Data',
                          ),
                          _row('Operating Hours', _operatingHours()),
                          _row(
                            'Monthly Bill',
                            () {
                              final v = (_proj['averageMonthlyBill'] as num?)?.toDouble() ?? 0;
                              if (v <= 0) return 'No Data';
                              final s = v == v.truncateToDouble()
                                  ? v.toInt().toString()
                                  : v.toStringAsFixed(2);
                              return '$s JOD';
                            }(),
                          ),
                        ]),
                        const SizedBox(height: 24),

                        // ── Project Costs ─────────────────────────────
                        _sectionTitle('Project Costs'),
                        const SizedBox(height: 12),
                        _card([
                          _costRow('Transportation',
                              _costs['transportationCost'] as String?),
                          _costRow('Machinery Operating',
                              _costs['machineryOperatingCost'] as String?),
                          _row('Engineers', _engineerCostDisplay()),
                          _costRow('Other', _costs['otherCosts'] as String?),
                        ]),
                        const SizedBox(height: 24),

                        // ── Assigned Engineers ────────────────────────
                        _sectionTitle('Assigned Engineers'),
                        const SizedBox(height: 12),
                        _engineersTable(),
                        const SizedBox(height: 24),

                        // ── Bills Info ────────────────────────────────
                        _sectionTitle('Bills Info'),
                        const SizedBox(height: 12),
                        _billsTable(),
                        const SizedBox(height: 24),

                        // ── Energy Consumption Breakdown ──────────────
                        _sectionTitle('Energy consumption breakdown'),
                        const SizedBox(height: 12),
                        _energyBreakdownCard(),
                        const SizedBox(height: 12),
                        _totalConsumptionCard(),
                        const SizedBox(height: 24),

                        // ── Audit Notes ───────────────────────────────
                        _sectionTitle('Audit Notes'),
                        const SizedBox(height: 12),
                        _auditNotesBox(notes),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                child: Footer(
                  currentStep: 0,
                  onNext: () {},
                  onBack: () => Navigator.pop(context),
                  mode: FooterMode.backOnly,
                ),
              ),
            ],
          ),

          // ── index 1: All Contacts ───────────────────────────────────────
          AllContactPage(
            onBack: _closeSection,
            clientInfo: _clientInfo,
            projectId: customId,
          ),

          // ── index 2: Lighting review ────────────────────────────────────
          LightingReview(onBack: _closeSection, lightingData: _lighting),

          // ── index 3: AC / HVAC review ───────────────────────────────────
          AcReview(onBack: _closeSection, acData: _ac),

          // ── index 4: Equipment review ───────────────────────────────────
          EquipmentReview(onBack: _closeSection, equipmentData: _equipment),

          // ── index 5: Production / Machines review ───────────────────────
          ProductionReview(onBack: _closeSection, machinesData: _machines),
        ],
      ),
    );
  }

  // ── widget helpers ─────────────────────────────────────────────────────────

  Widget _sectionTitle(String text) => Text(
        text,
        style: GoogleFonts.firaSans(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
      );

  /// Bordered card wrapping a column of rows separated by dividers.
  Widget _card(List<Widget> rows) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i < rows.length - 1)
              const Divider(
                  height: 1, thickness: 1, color: Color(0xFFA8A6A7)),
          ],
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: GoogleFonts.firaSans(
                    fontSize: 24, fontWeight: FontWeight.w400)),
            Text(value,
                style: GoogleFonts.firaSans(
                    fontSize: 24, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _costRow(String label, String? value) {
    final display =
        (value == null || value.trim().isEmpty) ? 'No Data' : '$value JOD';
    return _row(label, display);
  }

  Widget _viewAllContactsRow() {
    return GestureDetector(
      onTap: _openContacts,
      child: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'View All Contacts',
                style: GoogleFonts.firaSans(
                    fontSize: 24, fontWeight: FontWeight.w400),
              ),
              SvgPicture.asset(
                'assets/images/arrowright.svg',
                width: 40,
                height: 40,
                colorFilter:
                    ColorFilter.mode(primaryColor, BlendMode.srcIn),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
                    height: 1, thickness: 1, color: Color(0xFFA8A6A7)),
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
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: GoogleFonts.firaSans(
                      fontSize: 24, fontWeight: FontWeight.w400)),
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
                      colorFilter:
                          ColorFilter.mode(primaryColor, BlendMode.srcIn),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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
            style:
                GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _engineersTable() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: tablelinescolor, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(0.4),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1.2),
          },
          border: TableBorder.symmetric(
            inside: BorderSide(color: tablelinescolor, width: 1),
          ),
          children: [
            TableRow(children: [
              _engHeader('ID'),
              _engHeader('Name'),
              _engHeader('Contact Info'),
            ]),
            if (_engineers.isEmpty)
              TableRow(children: [
                _engCell('—'),
                _engCell('No engineers assigned'),
                _engCell('—'),
              ])
            else
              for (final eng in _engineers)
                TableRow(children: [
                  _engCell(eng['customId'] as String? ?? '—'),
                  _engCell(_v(eng['name'] as String?)),
                  _engCell(_v(eng['email'] as String?)),
                ]),
          ],
        ),
      ),
    );
  }

  Widget _engHeader(String text) => Padding(
        padding: const EdgeInsets.all(10),
        child: Text(text,
            style: GoogleFonts.firaSans(
                fontSize: 24, fontWeight: FontWeight.w500)),
      );

  Widget _engCell(String text) => Padding(
        padding: const EdgeInsets.all(10),
        child: Text(text, style: GoogleFonts.firaSans(fontSize: 24)),
      );

  Widget _billsTable() {
    final rawBills = _proj['bills'] as List? ?? [];
    final bills = rawBills
        .map((b) => b as Map<String, dynamic>)
        .where(
            (b) => (double.tryParse(b['billAmount'] as String? ?? '') ?? 0) > 0)
        .toList();

    final avgRaw = _proj['averageMonthlyBill'];
    final avgVal = avgRaw != null ? (avgRaw as num).toDouble() : 0.0;
    final avgDisplay = avgVal > 0
        ? '${avgVal == avgVal.truncateToDouble() ? avgVal.toInt() : avgVal.toStringAsFixed(2)} JOD'
        : 'No Data';

    String maxMonth = '—', maxCost = 'No Data';
    String minMonth = '—', minCost = 'No Data';

    if (bills.isNotEmpty) {
      final maxB = bills.reduce((a, b) =>
          (double.tryParse(a['billAmount'] as String? ?? '') ?? 0) >=
                  (double.tryParse(b['billAmount'] as String? ?? '') ?? 0)
              ? a
              : b);
      final minB = bills.reduce((a, b) =>
          (double.tryParse(a['billAmount'] as String? ?? '') ?? 0) <=
                  (double.tryParse(b['billAmount'] as String? ?? '') ?? 0)
              ? a
              : b);
      maxMonth = maxB['month'] as String? ?? '—';
      maxCost = '${maxB['billAmount']} JOD';
      minMonth = minB['month'] as String? ?? '—';
      minCost = '${minB['billAmount']} JOD';
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: tablelinescolor, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            _billsRowSpanned('Average Bill Cost', avgDisplay),
            Divider(color: tablelinescolor, height: 1, thickness: 1),
            _billsRowTriple('Max/Min', 'Month', 'Cost', isHeader: true),
            Divider(color: tablelinescolor, height: 1, thickness: 1),
            _billsRowTriple('Max Bill Cost', maxMonth, maxCost),
            Divider(color: tablelinescolor, height: 1, thickness: 1),
            _billsRowTriple('Min Bill Cost', minMonth, minCost),
          ],
        ),
      ),
    );
  }

  Widget _billsRowSpanned(String label, String value) {
    return SizedBox(
      height: 69,
      child: Row(
        children: [
          Container(
            width: 220,
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Text(label,
                style: GoogleFonts.firaSans(
                    fontSize: 24, fontWeight: FontWeight.w400)),
          ),
          Container(width: 1, color: tablelinescolor),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(value,
                    style: GoogleFonts.firaSans(
                        fontSize: 24, fontWeight: FontWeight.w400)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _billsRowTriple(
    String col1,
    String col2,
    String col3, {
    bool isHeader = false,
  }) {
    final weight = isHeader ? FontWeight.w500 : FontWeight.w400;
    return SizedBox(
      height: 69,
      child: Row(
        children: [
          Container(
            width: 220,
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Text(col1,
                style: GoogleFonts.firaSans(fontSize: 24, fontWeight: weight)),
          ),
          Container(width: 1, color: tablelinescolor),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(col2,
                    style: GoogleFonts.firaSans(
                        fontSize: 24, fontWeight: weight)),
              ),
            ),
          ),
          Container(width: 1, color: tablelinescolor),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(col3,
                    style: GoogleFonts.firaSans(
                        fontSize: 24, fontWeight: weight)),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
