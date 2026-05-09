import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/section_head_pages/shared_files/fotter.dart';

class BillsBody extends StatefulWidget {
  final VoidCallback onBack;

  const BillsBody({super.key, required this.onBack});

  @override
  State<BillsBody> createState() => _BillsBodyState();
}

class _BillsBodyState extends State<BillsBody> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  List<String> _getLast12Months() {
    final now = DateTime.now();
    final startMonth = DateTime(now.year, now.month - 12);
    final months = <String>[];
    final monthNames = [
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
    for (int i = 0; i < 12; i++) {
      final date = DateTime(startMonth.year, startMonth.month + i);
      months.add('${monthNames[date.month - 1]} ${date.year}');
    }
    return months;
  }

  @override
  Widget build(BuildContext context) {
    final months = _getLast12Months();

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
                    top: BorderSide(color: Colors.black, width: 1),
                    bottom: BorderSide(color: Colors.black, width: 1),
                    left: BorderSide(color: Colors.black, width: 1),
                    right: BorderSide(color: Colors.black, width: 1),
                    horizontalInside: BorderSide(color: Colors.black, width: 1),
                    verticalInside: BorderSide(color: Colors.black, width: 1),
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
                    ...months.map(
                      (month) => TableRow(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            height: 68,
                            child: Text(
                              month,
                              style: GoogleFonts.firaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            height: 68,
                            child: TextField(
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
