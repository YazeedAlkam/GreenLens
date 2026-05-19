import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/shared_files/footer.dart';

class ReviewBody extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final VoidCallback onViewAllContacts;
  final Future<void> Function() onSaveProject;
  final Map<String, dynamic> clientInfo;
  final Map<String, dynamic> projectInfo;
  final List<Map<String, dynamic>> assignedEngineers;
  final Map<String, dynamic> costs;
  final String projectId;
  final bool readOnly;

  const ReviewBody({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    required this.onViewAllContacts,
    required this.onSaveProject,
    required this.clientInfo,
    required this.projectInfo,
    required this.assignedEngineers,
    required this.costs,
    required this.projectId,
    this.readOnly = false,
  });

  @override
  State<ReviewBody> createState() => _ReviewBodyState();
}

class _ReviewBodyState extends State<ReviewBody>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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

  String _totalCostDisplay(
    Map<String, dynamic> costs,
    List<Map<String, dynamic>> engs,
    Map<String, dynamic> proj,
  ) {
    final t = double.tryParse(costs['transportationCost'] as String? ?? '') ?? 0;
    final m =
        double.tryParse(costs['machineryOperatingCost'] as String? ?? '') ?? 0;
    final o = double.tryParse(costs['otherCosts'] as String? ?? '') ?? 0;
    final engDisplay = _engineerCostDisplay(engs, proj);
    final e = engDisplay == 'No Data'
        ? 0.0
        : double.tryParse(engDisplay.replaceAll(' JOD', '')) ?? 0;
    final total = t + m + o + e;
    if (total == 0) return 'No Data';
    final formatted = total == total.truncateToDouble()
        ? total.toInt().toString()
        : total.toStringAsFixed(2);
    return '$formatted JOD';
  }

  String _engineerCostDisplay(
    List<Map<String, dynamic>> engs,
    Map<String, dynamic> proj,
  ) {
    final start = _parseDate(proj['initiationDate'] as String?);
    final end = _parseDate(proj['deadlineDate'] as String?);
    if (start == null || end == null || end.isBefore(start)) return 'No Data';
    final days = _workingDaysBetween(start, end);
    double total = 0;
    for (final eng in engs) {
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
    super.build(context);

    final main =
        widget.clientInfo['mainContact'] as Map<String, dynamic>? ?? {};
    final proj = widget.projectInfo;
    final engs = widget.assignedEngineers;
    final costs = widget.costs;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 30, 32, 0),
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────────────
            Row(
              children: [
                Text(
                  'Review',
                  style: GoogleFonts.firaSans(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Client Info",
                  style: GoogleFonts.firaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            // ── Client Info Table ─────────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: tablelinescolor, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Table(
                border: TableBorder.symmetric(
                  inside: BorderSide(color: tablelinescolor, width: 2),
                ),
                children: [
                  _infoRow(
                    "ID",
                    _v(widget.projectId.isEmpty ? null : widget.projectId),
                  ),
                  _infoRow("Full Name", _v(main['name'] as String?)),
                  _infoRow("Client Position", _v(main['position'] as String?)),
                  _infoRow("Client Email", _v(main['email'] as String?)),
                  _infoRow("Client Phone Number", _v(main['phone'] as String?)),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextButton(
                          onPressed: widget.onViewAllContacts,
                          style: TextButton.styleFrom(
                            overlayColor: Colors.transparent,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "View All Contacts",
                                  style: GoogleFonts.firaSans(
                                    color: Colors.black,
                                    fontSize: 24,
                                  ),
                                ),
                                SvgPicture.asset(
                                  "assets/images/arrowright.svg",
                                  width: 40,
                                  height: 40,
                                  colorFilter: ColorFilter.mode(
                                    primaryColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            // ── Project Info ──────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Project Info",
                  style: GoogleFonts.firaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: tablelinescolor, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Table(
                border: TableBorder.symmetric(
                  inside: BorderSide(color: tablelinescolor, width: 2),
                ),
                children: [
                  _infoRow("Project Name", _v(proj['projectName'] as String?)),
                  _infoRow(
                    "Building Type",
                    _v(proj['buildingType'] as String?),
                  ),
                  _infoRow(
                    "Initiation Date",
                    _v(proj['initiationDate'] as String?),
                  ),
                  _infoRow(
                    "Deadline Date",
                    _v(proj['deadlineDate'] as String?),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            // ── Project Costs ─────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Project Costs",
                  style: GoogleFonts.firaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: tablelinescolor, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Table(
                border: TableBorder.symmetric(
                  inside: BorderSide(color: tablelinescolor, width: 2),
                ),
                children: [
                  _costRow(
                    "Transportation",
                    costs['transportationCost'] as String?,
                  ),
                  _costRow(
                    "Machinery Operating",
                    costs['machineryOperatingCost'] as String?,
                  ),
                  _rawCostRow("Engineers", _engineerCostDisplay(engs, proj)),
                  _costRow("Other", costs['otherCosts'] as String?),
                  _rawCostRow("Total", _totalCostDisplay(costs, engs, proj)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            // ── Assigned Engineers ────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Assigned Engineers",
                  style: GoogleFonts.firaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: tablelinescolor, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(0.19),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(1),
                },
                border: TableBorder.symmetric(
                  inside: BorderSide(color: tablelinescolor, width: 2),
                ),
                children: [
                  TableRow(
                    children: [
                      _engHeader('ID'),
                      _engHeader('Name'),
                      _engHeader('Contact Info'),
                    ],
                  ),
                  if (engs.isEmpty)
                    TableRow(
                      children: [
                        _engCell('—'),
                        _engCell('No engineers assigned'),
                        _engCell('—'),
                      ],
                    )
                  else
                    for (final eng in engs)
                      TableRow(
                        children: [
                          _engCell(_v(eng['id'] as String?)),
                          _engCell(_v(eng['name'] as String?)),
                          _engCell(_v(eng['email'] as String?)),
                        ],
                      ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Footer(
              currentStep: widget.currentStep,
              onNext: widget.onNext,
              onBack: widget.onBack,
              mode: widget.readOnly ? FooterMode.done : FooterMode.review,
              onSaveProject: widget.onSaveProject,
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  TableRow _costRow(String label, String? value) {
    final display =
        (value == null || value.trim().isEmpty) ? 'No Data' : '$value JOD';
    return _infoRow(label, display);
  }

  TableRow _rawCostRow(String label, String value) =>
      _infoRow(label, value);

  TableRow _infoRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
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

  Widget _engHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            text,
            style: GoogleFonts.firaSans(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _engCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [Text(text, style: GoogleFonts.firaSans(fontSize: 24))],
      ),
    );
  }
}
