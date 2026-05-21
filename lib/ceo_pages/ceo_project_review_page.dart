import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/firebase/project_service.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/section_head_pages/create_new_project/all_contacts_body.dart';
import 'package:greenlens/shared_files/custom_app_bar.dart';
import 'package:greenlens/shared_files/footer.dart';

class CeoProjectReviewPage extends StatefulWidget {
  final Map<String, dynamic> project;

  const CeoProjectReviewPage({super.key, required this.project});

  @override
  State<CeoProjectReviewPage> createState() => _CeoProjectReviewPageState();
}

class _CeoProjectReviewPageState extends State<CeoProjectReviewPage> {
  final _projectService = ProjectService();
  List<Map<String, dynamic>> _engineers = [];
  bool _loadingEngineers = true;
  bool _showingContacts = false;
  @override
  void initState() {
    super.initState();
    _loadEngineers();
  }

  Future<void> _loadEngineers() async {
    final assignedIds = List<String>.from(
      widget.project['assignedEngineers'] as List? ?? [],
    );
    if (assignedIds.isEmpty) {
      if (mounted) setState(() => _loadingEngineers = false);
      return;
    }
    final all = await _projectService.getEngineers();
    final assigned =
        all.where((e) => assignedIds.contains(e['id'] as String)).toList();
    if (mounted) {
      setState(() {
        _engineers = assigned;
        _loadingEngineers = false;
      });
    }
  }

  void _openContacts() => setState(() => _showingContacts = true);
  void _closeContacts() => setState(() => _showingContacts = false);

  Future<void> _acceptProject() async {
    await _projectService.updateFields(
      widget.project['id'] as String,
      {'status': 'In Progress'},
    );
    if (mounted) Navigator.pop(context, true);
  }

  Future<void> _denyProject() async {
    await _projectService.updateFields(
      widget.project['id'] as String,
      {'status': 'Denied'},
    );
    if (mounted) Navigator.pop(context, true);
  }

  String _v(String? value) =>
      (value == null || value.trim().isEmpty) ? 'No Data' : value;

  DateTime? _parseDate(String? s) {
    if (s == null || s.trim().isEmpty) return null;
    final parts = s.split('/');
    if (parts.length != 3) return null;
    final d = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final y = int.tryParse(parts[2]);
    if (d == null || m == null || y == null) return null;
    return DateTime(y, m, d);
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

  String _engineerCostDisplay() {
    final proj = widget.project['projectInfo'] as Map<String, dynamic>? ?? {};
    final start = _parseDate(proj['initiationDate'] as String?);
    final end = _parseDate(proj['deadlineDate'] as String?);
    if (start == null || end == null || end.isBefore(start)) return 'No Data';
    final days = _workingDaysBetween(start, end);
    double total = 0;
    for (final eng in _engineers) {
      final rate = (eng['rate'] as num?)?.toDouble() ?? 0;
      total += rate * 8 * days;
    }
    if (total == 0) return 'No Data';
    final formatted = total == total.truncateToDouble()
        ? total.toInt().toString()
        : total.toStringAsFixed(2);
    return '$formatted JOD';
  }

  @override
  Widget build(BuildContext context) {
    final proj = widget.project['projectInfo'] as Map<String, dynamic>? ?? {};
    final costs = widget.project['costs'] as Map<String, dynamic>? ?? {};
    final main =
        ((widget.project['clientInfo'] as Map<String, dynamic>?)?['mainContact']
            as Map<String, dynamic>?) ??
        {};
    final customId = widget.project['customId'] as String? ?? '';
    final projectName = _v(proj['projectName'] as String?);

    return Scaffold(
      appBar: CustomAppBar.build(
        title: 'Review $projectName',
        subtitle: 'Accept or Deny Project',
      ),
      body: IndexedStack(
        index: _showingContacts ? 1 : 0,
        children: [
          // ── index 0: main overview ──────────────────────────────────────
          Column(
            children: [
              Expanded(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.white, Colors.transparent],
                      stops: [0.0, 0.93, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(32, 30, 32, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Client Info
                        _sectionTitle('Client Info'),
                        const SizedBox(height: 16),
                        _infoTable([
                          _infoRow('ID', _v(customId)),
                          _infoRow('Full Name', _v(main['name'] as String?)),
                          _infoRow(
                            'Client Position',
                            _v(main['position'] as String?),
                          ),
                          _infoRow(
                            'Client Email',
                            _v(main['email'] as String?),
                          ),
                          _infoRow(
                            'Client Phone Number',
                            _v(main['phone'] as String?),
                          ),
                          _viewAllContactsRow(),
                        ]),
                        const SizedBox(height: 16),

                        // Project Info
                        _sectionTitle('Project Info'),
                        const SizedBox(height: 16),
                        _infoTable([
                          _infoRow(
                            'Project Name',
                            _v(proj['projectName'] as String?),
                          ),
                          _infoRow(
                            'Building Type',
                            _v(proj['buildingType'] as String?),
                          ),
                          _infoRow(
                            'Initiation Date',
                            _v(proj['initiationDate'] as String?),
                          ),
                          _infoRow(
                            'Deadline Date',
                            _v(proj['deadlineDate'] as String?),
                          ),
                        ]),
                        const SizedBox(height: 16),

                        // Project Costs
                        _sectionTitle('Project Costs'),
                        const SizedBox(height: 16),
                        _infoTable([
                          _costRow(
                            'Transportation',
                            costs['transportationCost'] as String?,
                          ),
                          _costRow(
                            'Machinery Operating',
                            costs['machineryOperatingCost'] as String?,
                          ),
                          _rawInfoRow('Engineers', _engineerCostDisplay()),
                          _costRow('Other', costs['otherCosts'] as String?),
                        ]),
                        const SizedBox(height: 16),

                        // Bills Info
                        _sectionTitle('Bills Info'),
                        const SizedBox(height: 16),
                        _billsInfoTable(),
                        const SizedBox(height: 16),

                        // Assigned Engineers
                        _sectionTitle('Assigned Engineers'),
                        const SizedBox(height: 16),
                        _engineersTable(),
                        const SizedBox(height: 16),

                        // Audit Notes
                        _sectionTitle('Audit Notes'),
                        const SizedBox(height: 16),
                        _auditNotesBox(),
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
                  mode: FooterMode.acceptDeny,
                  onAccept: _acceptProject,
                  onDeny: _denyProject,
                ),
              ),
            ],
          ),

          // ── index 1: All Contacts body ──────────────────────────────────
          AllContactPage(
            onBack: _closeContacts,
            clientInfo:
                widget.project['clientInfo'] as Map<String, dynamic>? ?? {},
            projectId: widget.project['customId'] as String? ?? '',
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.firaSans(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
    );
  }

  Widget _infoTable(List<TableRow> rows) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: tablelinescolor, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Table(
          border: TableBorder.symmetric(
            inside: BorderSide(color: tablelinescolor, width: 1),
          ),
          children: rows,
        ),
      ),
    );
  }

  TableRow _infoRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
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
      ],
    );
  }

  TableRow _rawInfoRow(String label, String value) => _infoRow(label, value);

  TableRow _costRow(String label, String? value) {
    final display =
        (value == null || value.trim().isEmpty) ? 'No Data' : '$value JOD';
    return _infoRow(label, display);
  }

  TableRow _viewAllContactsRow() {
    return TableRow(
      children: [
        GestureDetector(
          onTap: _openContacts,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'View All Contacts',
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/arrowright.svg',
                  width: 40,
                  height: 40,
                  colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _engineersTable() {
    if (_loadingEngineers) {
      return const Center(child: CircularProgressIndicator());
    }
    return Container(
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
            TableRow(
              children: [
                _engHeader('ID'),
                _engHeader('Name'),
                _engHeader('Contact Info'),
              ],
            ),
            if (_engineers.isEmpty)
              TableRow(
                children: [
                  _engCell('—'),
                  _engCell('No engineers assigned'),
                  _engCell('—'),
                ],
              )
            else
              for (final eng in _engineers)
                TableRow(
                  children: [
                    _engCell(eng['customId'] as String? ?? '—'),
                    _engCell(_v(eng['name'] as String?)),
                    _engCell(_v(eng['email'] as String?)),
                  ],
                ),
          ],
        ),
      ),
    );
  }

  Widget _engHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        style: GoogleFonts.firaSans(
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _engCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(text, style: GoogleFonts.firaSans(fontSize: 24)),
    );
  }

  Widget _billsInfoTable() {
    final proj = widget.project['projectInfo'] as Map<String, dynamic>? ?? {};
    final rawBills = proj['bills'] as List? ?? [];
    final bills = rawBills
        .map((b) => b as Map<String, dynamic>)
        .where((b) {
          final v = double.tryParse(b['billAmount'] as String? ?? '') ?? 0;
          return v > 0;
        })
        .toList();

    final avgRaw = proj['averageMonthlyBill'];
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
            child: Text(
              label,
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(width: 1, color: tablelinescolor),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  value,
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
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
            child: Text(
              col1,
              style: GoogleFonts.firaSans(fontSize: 24, fontWeight: weight),
            ),
          ),
          Container(width: 1, color: tablelinescolor),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  col2,
                  style:
                      GoogleFonts.firaSans(fontSize: 24, fontWeight: weight),
                ),
              ),
            ),
          ),
          Container(width: 1, color: tablelinescolor),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  col3,
                  style:
                      GoogleFonts.firaSans(fontSize: 24, fontWeight: weight),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _auditNotesBox() {
    final notes = widget.project['auditNotes'] as String? ?? '';
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
