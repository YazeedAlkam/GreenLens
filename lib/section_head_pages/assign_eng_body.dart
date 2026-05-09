// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/section_head_pages/shared_files/fotter.dart';

class AssignEngBody extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;

  const AssignEngBody({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
  });

  @override
  State<AssignEngBody> createState() => _AssignEngBodyState();
}

class _AssignEngBodyState extends State<AssignEngBody> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  // Each engineer has: id, name, email, and isAssigned (true = remove, false = add)
  final List<Map<String, dynamic>> _engineers = [
    {
      'id': '05',
      'name': 'Ahmad',
      'email': 'Ahmad@gmail.com',
      'isAssigned': false,
    },
    {
      'id': '11',
      'name': 'Mohammad',
      'email': 'Mohammad@gmail.com',
      'isAssigned': true,
    },
    // TODO: replace with real data from backend
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Assign Engineers",
            style: GoogleFonts.firaSans(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
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
                  top: const BorderSide(color: Colors.black, width: 2),
                  bottom: const BorderSide(color: Colors.black, width: 2),
                  left: const BorderSide(color: Colors.black, width: 2),
                  right: const BorderSide(color: Colors.black, width: 2),
                  horizontalInside: const BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  verticalInside: const BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                columnWidths: const {
                  0: FlexColumnWidth(0.25),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(0.35),
                },
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: Colors.white),
                    children: [
                      _headerCell('ID'),
                      _headerCell('Name'),
                      _headerCell('Email'),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            'Add &\nRemove',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.firaSans(
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ..._engineers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final eng = entry.value;
                    final bool isAssigned = eng['isAssigned'] as bool;

                    return TableRow(
                      children: [
                        _dataCell(eng['id']),
                        _dataCell(eng['name']),
                        _dataCell(eng['email']),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            height: 49,
                            width: 109.23,
                            decoration: BoxDecoration(
                              color: isAssigned ? removeEngColor : addengColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _engineers[index]['isAssigned'] = !isAssigned;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isAssigned
                                    ? removeEngColor
                                    : addengColor,
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: SvgPicture.asset(
                                isAssigned
                                    ? 'assets/images/Minus.svg'
                                    : 'assets/images/Add.svg',
                                color: isAssigned ? deniedColor : primaryColor,
                                width: 27,
                                height: 27,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          CreateNewProjectFooter(
            currentStep: widget.currentStep,
            onNext: widget.onNext,
            onBack: widget.onBack,
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _headerCell(String text) {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.centerLeft,
      height: 88,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: GoogleFonts.firaSans(
          fontWeight: FontWeight.w600,
          color: primaryColor,
          fontSize: 24,
        ),
      ),
    );
  }

  Widget _dataCell(String text) {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.centerLeft,
      height: 69,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w600),
      ),
    );
  }
}
