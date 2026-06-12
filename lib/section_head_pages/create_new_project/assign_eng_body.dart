import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/firebase/project_service.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/shared_files/footer.dart';

/// Step 3 of the Create Project wizard: selecting which engineers to assign.
///
/// Loads all available engineers from Firestore and lets the Section Head
/// toggle their selection. Pre-selects [initialAssignedEngineers] when editing.
class AssignEngBody extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final Future<void> Function() onSaveDraft;
  final List<String>? initialAssignedEngineers;
  final bool readOnly;

  const AssignEngBody({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    required this.onSaveDraft,
    this.initialAssignedEngineers,
    this.readOnly = false,
  });

  @override
  State<AssignEngBody> createState() => AssignEngBodyState();
}

/// State for [AssignEngBody]. Exposes [getAssignedEngineers] (UIDs for
/// Firestore) and [getAssignedEngineersInfo] (display info) via [GlobalKey].
class AssignEngBodyState extends State<AssignEngBody>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<Map<String, dynamic>> _engineers = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEngineers();
  }

  /// Fetches all engineers from Firestore and marks the ones that were
  /// already assigned (when editing a draft) as selected.
  Future<void> _loadEngineers() async {
    try {
      final engineers = await ProjectService().getEngineers();
      if (mounted) {
        final preAssigned = widget.initialAssignedEngineers ?? [];
        setState(() {
          _engineers.addAll(
            engineers.map(
              (e) => {...e, 'isAssigned': preAssigned.contains(e['id'])},
            ),
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  /// Firebase Auth UIDs of the selected engineers — what gets stored in the
  /// project's `assignedEngineers` array.
  List<String> getAssignedEngineers() {
    return _engineers
        .where((e) => e['isAssigned'] == true)
        .map((e) => e['id'] as String)
        .toList();
  }

  /// Display info (customId, name, email, hourly rate) of the selected
  /// engineers — used by the Review step and the engineer-cost calculation.
  List<Map<String, dynamic>> getAssignedEngineersInfo() {
    return _engineers
        .where((e) => e['isAssigned'] == true)
        .map(
          (e) => {
            'id': e['customId'] as String,
            'name': e['name'] as String,
            'email': e['email'] as String,
            'rate': e['rate'],
          },
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.readOnly ? "Assigned Engineers" : "Assign Engineers",
            style: GoogleFonts.firaSans(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: dividerColor),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            Center(child: Text('Error loading engineers: $_error'))
          else
            Builder(builder: (context) {
              // In read-only mode only show the engineers actually assigned;
              // in edit mode show everyone so they can be toggled.
              final displayed = widget.readOnly
                  ? _engineers.where((e) => e['isAssigned'] == true).toList()
                  : _engineers;
              return Container(
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
                    columnWidths: widget.readOnly
                        ? const {
                            0: FlexColumnWidth(0.25),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                          }
                        : const {
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
                          if (!widget.readOnly)
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
                      if (widget.readOnly && displayed.isEmpty)
                        TableRow(
                          children: [
                            _dataCell('—'),
                            _dataCell('No engineers assigned'),
                            _dataCell('—'),
                          ],
                        )
                      else
                        ...displayed.asMap().entries.map((entry) {
                          final eng = entry.value;
                          final bool isAssigned = eng['isAssigned'] as bool;
                          final globalIndex = _engineers.indexOf(eng);

                          return TableRow(
                            children: [
                              _dataCell(eng['customId']),
                              _dataCell(eng['name']),
                              _dataCell(eng['email']),
                              if (!widget.readOnly)
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    height: 49,
                                    width: 109.23,
                                    decoration: BoxDecoration(
                                      color: isAssigned
                                          ? removeEngColor
                                          : addengColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _engineers[globalIndex][
                                              'isAssigned'] = !isAssigned;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isAssigned
                                            ? removeEngColor
                                            : addengColor,
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: SvgPicture.asset(
                                        isAssigned
                                            ? 'assets/images/Minus.svg'
                                            : 'assets/images/Add.svg',
                                        colorFilter: isAssigned
                                            ? ColorFilter.mode(
                                                deniedColor,
                                                BlendMode.srcIn,
                                              )
                                            : ColorFilter.mode(
                                                primaryColor,
                                                BlendMode.srcIn,
                                              ),
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
              );
            }),

          const SizedBox(height: 32),

          Footer(
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

  /// Green bold header cell for the engineers table.
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

  /// Plain data cell for the engineers table.
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
