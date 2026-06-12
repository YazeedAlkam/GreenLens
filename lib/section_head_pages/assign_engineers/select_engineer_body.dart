import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/firebase/project_service.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/shared_files/footer.dart';

/// Step 2 of the Assign Engineers flow: pick one or more engineers for the project.
///
/// Pre-selects engineers already assigned to [project] and persists changes
/// to Firestore when saved. Calls [onSaved] on success.
class SelectEngineerBody extends StatefulWidget {
  final Map<String, dynamic> project;
  final VoidCallback onBack;
  final VoidCallback onSaved;

  const SelectEngineerBody({
    super.key,
    required this.project,
    required this.onBack,
    required this.onSaved,
  });

  @override
  State<SelectEngineerBody> createState() => _SelectEngineerBodyState();
}

/// State for [SelectEngineerBody]. Manages engineer list, selection set,
/// and the save operation.
class _SelectEngineerBodyState extends State<SelectEngineerBody> {
  final List<Map<String, dynamic>> _engineers = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEngineers();
  }

  /// Fetches all engineers and pre-selects those already assigned to the project.
  Future<void> _loadEngineers() async {
    try {
      final engineers = await ProjectService().getEngineers();
      if (!mounted) return;
      final alreadyAssigned =
          (widget.project['assignedEngineers'] as List?)?.cast<String>() ?? [];
      setState(() {
        _engineers.addAll(
          engineers.map(
            (e) => {...e, 'isAssigned': alreadyAssigned.contains(e['id'])},
          ),
        );
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  /// Persists the current selection to the project's `assignedEngineers`
  /// array in Firestore, then notifies the parent flow via [widget.onSaved].
  Future<void> _saveProject() async {
    try {
      final ids = _engineers
          .where((e) => e['isAssigned'] == true)
          .map((e) => e['id'] as String)
          .toList();
      await ProjectService().updateAssignedEngineers(
        widget.project['id'] as String,
        ids,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Engineers saved')),
      );
      widget.onSaved();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
    } finally {
      if (mounted) {}
    }
  }

  /// Display name for the page title: project name, falling back to its
  /// custom ID, then a generic label.
  String get _projectName {
    return (widget.project['projectInfo']
            as Map<String, dynamic>?)?['projectName'] ??
        widget.project['customId'] ??
        'Project';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(32, 30, 32, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assign Engineers to $_projectName',
                  style: GoogleFonts.firaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_error != null)
                  Text(
                    'Error: $_error',
                    style: GoogleFonts.firaSans(color: Colors.red),
                  )
                else
                  _buildTable(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
          child: Footer(
            currentStep: 0,
            onNext: () {},
            onBack: widget.onBack,
            mode: FooterMode.review,
            onSaveProject: _saveProject,
          ),
        ),
      ],
    );
  }

  /// Engineer table with an Add/Remove toggle button per row (same layout
  /// as the Assign Engineers step in the Create Project wizard).
  Widget _buildTable() {
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
            horizontalInside: const BorderSide(color: Colors.black, width: 2),
            verticalInside: const BorderSide(color: Colors.black, width: 2),
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
                  _dataCell(eng['customId']),
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
                          colorFilter: isAssigned ? ColorFilter.mode(deniedColor, BlendMode.srcIn) : ColorFilter.mode(primaryColor, BlendMode.srcIn),
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
  }

  /// Green bold header cell for the engineers table.
  Widget _headerCell(String text) {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.centerLeft,
      height: 88,
      child: Text(
        text,
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
      padding: const EdgeInsets.all(10),
      alignment: Alignment.centerLeft,
      height: 69,
      child: Text(
        text,
        style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w600),
      ),
    );
  }
}
