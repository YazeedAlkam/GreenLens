import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/shared_files/footer.dart';

/// Sub-page (overlaid during Create Project) for entering 12 monthly utility
/// bills. Computes the average monthly bill and reports it via [onAverageChanged].
class BillsBody extends StatefulWidget {
  final VoidCallback onBack;
  final void Function(double)? onAverageChanged;
  final List<Map<String, dynamic>>? initialBills;
  final double? initialAverageBill;

  const BillsBody({
    super.key,
    required this.onBack,
    this.onAverageChanged,
    this.initialBills,
    this.initialAverageBill,
  });

  @override
  State<BillsBody> createState() => BillsBodyState();
}

/// State for [BillsBody]. Exposes [getBillsData] via [GlobalKey].
class BillsBodyState extends State<BillsBody>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final List<String> _months;
  late final List<TextEditingController> _energyCtrls;
  late final List<TextEditingController> _billCtrls;
  double _averageMonthlyBill = 0;

  @override
  void initState() {
    super.initState();
    _months = _getLast12Months();
    _energyCtrls = List.generate(12, (_) => TextEditingController());
    _billCtrls = List.generate(12, (_) => TextEditingController());

    final initial = widget.initialBills;
    if (initial != null) {
      for (int i = 0; i < 12 && i < initial.length; i++) {
        _energyCtrls[i].text = initial[i]['energyConsumed']?.toString() ?? '';
        _billCtrls[i].text = initial[i]['billAmount']?.toString() ?? '';
      }
    }
    _averageMonthlyBill = widget.initialAverageBill ?? 0;

    // Recompute the average live as the user types any bill amount.
    for (final ctrl in _billCtrls) {
      ctrl.addListener(_recalculateAverage);
    }
  }

  @override
  void dispose() {
    for (final c in _energyCtrls) {
      c.dispose();
    }
    for (final c in _billCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  /// Averages only the bill fields that contain a value > 0, so empty
  /// months don't drag the average down. Pushes the result up to
  /// [ProjectInfoBody] through [BillsBody.onAverageChanged].
  void _recalculateAverage() {
    final values = _billCtrls
        .map((c) => double.tryParse(c.text) ?? 0)
        .where((v) => v > 0)
        .toList();
    final avg = values.isEmpty
        ? 0.0
        : values.reduce((a, b) => a + b) / values.length;
    setState(() => _averageMonthlyBill = avg);
    widget.onAverageChanged?.call(avg);
  }

  /// Returns the 12 rows (month, energy consumed, bill amount) plus the
  /// computed average — stored under `projectInfo` in Firestore.
  Map<String, dynamic> getBillsData() {
    return {
      'bills': List.generate(
        12,
        (i) => {
          'month': _months[i],
          'energyConsumed': _energyCtrls[i].text,
          'billAmount': _billCtrls[i].text,
        },
      ),
      'averageMonthlyBill': _averageMonthlyBill,
    };
  }

  /// Builds the row labels: the 12 calendar months immediately before the
  /// current month (e.g. in June 2026 → "June 2025" … "May 2026").
  List<String> _getLast12Months() {
    final now = DateTime.now();
    final startMonth = DateTime(now.year, now.month - 12);
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return List.generate(12, (i) {
      final date = DateTime(startMonth.year, startMonth.month + i);
      return '${monthNames[date.month - 1]} ${date.year}';
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bills Input',
              style: GoogleFonts.firaSans(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            Divider(color: dividerColor),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Table(
                  border: TableBorder(
                    top: const BorderSide(color: Colors.black, width: 1),
                    bottom: const BorderSide(color: Colors.black, width: 1),
                    left: const BorderSide(color: Colors.black, width: 1),
                    right: const BorderSide(color: Colors.black, width: 1),
                    horizontalInside: const BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                    verticalInside: const BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(color: Colors.white),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Month',
                            style: GoogleFonts.firaSans(
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Energy Consumed (kWh)',
                            style: GoogleFonts.firaSans(
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Bill's Amount",
                            style: GoogleFonts.firaSans(
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...List.generate(
                      12,
                      (i) => TableRow(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            height: 68,
                            child: Text(
                              _months[i],
                              style: GoogleFonts.firaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            height: 68,
                            child: TextField(
                              controller: _energyCtrls[i],
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]'),
                                ),
                              ],
                              minLines: 1,
                              maxLines: 1,
                              style: GoogleFonts.firaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: _billCtrls[i],
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]'),
                                ),
                              ],
                              minLines: 1,
                              maxLines: 1,
                              style: GoogleFonts.firaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Footer(
              currentStep: 2,
              onNext: () {},
              onBack: widget.onBack,
              mode: FooterMode.backOnly,
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
