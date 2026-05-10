import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/shared_files/fotter.dart';

class BillsBody extends StatefulWidget {
  final VoidCallback onBack;
  final void Function(double)? onAverageChanged;

  const BillsBody({super.key, required this.onBack, this.onAverageChanged});

  @override
  State<BillsBody> createState() => BillsBodyState();
}

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
            CreateNewProjectFooter(
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
