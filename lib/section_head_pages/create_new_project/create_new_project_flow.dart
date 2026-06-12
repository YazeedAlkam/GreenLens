import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/section_head_pages/create_new_project/project_info_body.dart';
import 'package:greenlens/section_head_pages/create_new_project/review_body.dart';
import 'package:greenlens/section_head_pages/create_new_project/shared_files/nav_bar.dart';
import 'package:greenlens/section_head_pages/create_new_project/shared_files/navbar_title.dart';
import '../../firebase/project_service.dart';
import '../../main.dart';
import 'all_contacts_body.dart';
import 'assign_eng_body.dart';
import 'bills_body.dart';
import 'cost_body.dart';
import 'client_info_body.dart';

/// 5-step wizard for the Section Head to create or edit a project.
///
/// Steps:
///   1. Client Info    — main contact, secondary contact, and extra contacts
///   2. Project Info   — building type, floor area, dates, operating hours, average bill
///   3. Assign Engineers — pick which engineers will perform the audit
///   4. Costs          — transportation, machinery, other costs (engineer cost auto-calculated)
///   5. Review         — final overview before submitting
///
/// Two hidden sub-pages can overlay any step:
///   - Bills page     (monthly utility bills input, accessed from Project Info step)
///   - All Contacts   (full contact list view, accessed from Review step)
///
/// If [existingProjectId] is provided, the flow loads the existing project data
/// and updates it. Otherwise a new project is created with a fresh sequential ID.
///
/// Saving as Draft keeps status = "Draft".
/// Submitting changes status to "Awaiting Approval" for CEO review.
class CreateProjectFlow extends StatefulWidget {
  final String? existingProjectId;
  final bool readOnly;
  const CreateProjectFlow({super.key, this.existingProjectId, this.readOnly = false});

  @override
  State<CreateProjectFlow> createState() => _CreateProjectFlowState();
}

/// State for [CreateProjectFlow]. Manages step navigation, form GlobalKeys,
/// and project save/submit logic.
class _CreateProjectFlowState extends State<CreateProjectFlow> {
  final _projectService = ProjectService();
  String? _projectId;
  String _nextProjectId = '';
  bool _loading = false;
  Map<String, dynamic>? _initialData;

  /// Parses a "d/M/yyyy" date string into a [DateTime], or returns null.
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

  /// Counts working days (Mon–Thu, Sun) between [start] and [end] inclusive,
  /// excluding Friday and Saturday (Jordanian weekend).
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

  /// Calculates the estimated engineer cost from the current form state.
  ///
  /// Formula: sum over all assigned engineers of (rate × 8 hrs × working days).
  /// Working days are counted between initiationDate and deadlineDate, excluding
  /// Fridays and Saturdays. Returns null if dates are missing or invalid.
  double? _computeEngineerCost() {
    final proj = _projectKey.currentState?.getProjectInfo() ?? {};
    final engs = _assignKey.currentState?.getAssignedEngineersInfo() ?? [];
    final start = _parseDate(proj['initiationDate'] as String?);
    final end = _parseDate(proj['deadlineDate'] as String?);
    if (start == null || end == null || end.isBefore(start)) return null;
    final days = _workingDaysBetween(start, end);
    double total = 0;
    for (final eng in engs) {
      final rate = (eng['rate'] as num?)?.toDouble() ?? 0;
      total += rate * 8 * days;
    }
    return total > 0 ? total : null;
  }

  final _clientKey = GlobalKey<ClientInfoBodyState>();
  final _projectKey = GlobalKey<ProjectInfoBodyState>();
  final _assignKey = GlobalKey<AssignEngBodyState>();
  final _costKey = GlobalKey<CostBodyState>();
  final _billsKey = GlobalKey<BillsBodyState>();

  @override
  void initState() {
    super.initState();
    if (widget.existingProjectId != null) {
      _loading = true;
      _loadExistingProject();
    } else {
      _projectService.getNextProjectId().then((id) {
        if (mounted) setState(() => _nextProjectId = id);
      });
    }
  }

  /// Loads the existing project document (when editing a draft or viewing
  /// read-only) so every step can pre-fill its form from [_initialData].
  Future<void> _loadExistingProject() async {
    final data = await _projectService.getProjectById(
      widget.existingProjectId!,
    );
    if (!mounted) return;
    setState(() {
      _projectId = widget.existingProjectId;
      _nextProjectId = data?['customId'] as String? ?? '';
      _initialData = data;
      _loading = false;
    });
  }

  /// Combines the Project Info form with the Bills sub-page data into the
  /// single `projectInfo` map stored on the Firestore document.
  Map<String, dynamic> _mergedProjectInfo() {
    return {
      ...?_projectKey.currentState?.getProjectInfo(),
      ...?_billsKey.currentState?.getBillsData(),
    };
  }

  /// Persists the project to Firestore with status = "Draft" and closes the flow.
  Future<void> _saveDraft() async {
    _projectId = await _projectService.saveProject(
      existingProjectId: _projectId,
      status: 'Draft',
      clientInfo: _clientKey.currentState?.getClientInfo() ?? {},
      projectInfo: _mergedProjectInfo(),
      assignedEngineers: _assignKey.currentState?.getAssignedEngineers() ?? [],
      costs: _costKey.currentState?.getCosts() ?? {},
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Draft saved')),
      );
      Navigator.pop(context);
    }
  }

  /// Persists the project with status = "Awaiting Approval" and closes the flow.
  /// This triggers the CEO review queue.
  Future<void> _saveProject() async {
    _projectId = await _projectService.saveProject(
      existingProjectId: _projectId,
      status: 'Awaiting Approval',
      clientInfo: _clientKey.currentState?.getClientInfo() ?? {},
      projectInfo: _mergedProjectInfo(),
      assignedEngineers: _assignKey.currentState?.getAssignedEngineers() ?? [],
      costs: _costKey.currentState?.getCosts() ?? {},
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project submitted for approval')),
      );
      Navigator.pop(context);
    }
  }

  int _currentStep = 0;
  bool _showingBills = false;
  bool _showingAllContacts = false;

  /// Advances to the next wizard step, or closes sub-pages (bills / all-contacts) first.
  void _next() {
    if (_showingBills) {
      setState(() => _showingBills = false);
      return;
    }
    if (_showingAllContacts) {
      setState(() => _showingAllContacts = false);
      return;
    }
    if (widget.readOnly && _currentStep == 4) {
      Navigator.pop(context);
      return;
    }
    if (_currentStep < 4) setState(() => _currentStep++);
  }

  /// Navigates backward, closing sub-pages first then decrementing the step.
  void _back() {
    if (_showingBills) {
      setState(() => _showingBills = false);
      return;
    }
    if (_showingAllContacts) {
      setState(() => _showingAllContacts = false);
      return;
    }
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  /// Shows the monthly bills sub-page on top of the current step.
  void _goToBills() => setState(() => _showingBills = true);

  /// Shows the all-contacts sub-page on top of the current step.
  void _goToAllContacts() => setState(() => _showingAllContacts = true);

  /// Jumps directly to [step] from the nav-bar and closes any open sub-pages.
  void _onStepTapped(int step) {
    setState(() {
      _currentStep = step;
      _showingBills = false;
      _showingAllContacts = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 200,
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        title: NavBarTitle(
          title: widget.readOnly
              ? ((_initialData?['projectInfo'] as Map<String, dynamic>?)?['projectName'] as String? ?? _nextProjectId)
              : 'Create New Project',
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                Text(
                  "Step ${_currentStep + 1} of 5",
                  style: GoogleFonts.firaSans(
                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 90, right: 90),
                  child: NavigationBarLines(
                    currentStep: _currentStep,
                    onStepTapped: _onStepTapped,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Builder(
              builder: (context) {
                final clientInfo =
                    _clientKey.currentState?.getClientInfo() ?? {};
                final projectInfo =
                    _projectKey.currentState?.getProjectInfo() ?? {};
                final assignedEngineers =
                    _assignKey.currentState?.getAssignedEngineersInfo() ?? [];
                final costs = _costKey.currentState?.getCosts() ??
                    (_initialData?['costs'] as Map<String, dynamic>? ?? {});

                // IndexedStack keeps every step mounted at once so form
                // state survives navigation. Indexes 0-4 are the wizard
                // steps; 5 = Bills sub-page, 6 = All Contacts sub-page.
                return IndexedStack(
                  index: _showingBills
                      ? 5
                      : _showingAllContacts
                      ? 6
                      : _currentStep,
                  children: [
                    ClientInfoBody(
                      key: _clientKey,
                      onNext: _next,
                      onBack: _back,
                      currentStep: _currentStep,
                      onSaveDraft: _saveDraft,
                      projectId: _nextProjectId,
                      initialClientInfo:
                          _initialData?['clientInfo'] as Map<String, dynamic>?,
                      readOnly: widget.readOnly,
                    ),
                    ProjectInfoBody(
                      key: _projectKey,
                      onNext: _next,
                      onBack: _back,
                      currentStep: _currentStep,
                      onViewBills: _goToBills,
                      onSaveDraft: _saveDraft,
                      initialProjectInfo:
                          _initialData?['projectInfo'] as Map<String, dynamic>?,
                      readOnly: widget.readOnly,
                    ),
                    AssignEngBody(
                      key: _assignKey,
                      onNext: _next,
                      onBack: _back,
                      currentStep: _currentStep,
                      onSaveDraft: _saveDraft,
                      initialAssignedEngineers:
                          (_initialData?['assignedEngineers'] as List?)
                              ?.cast<String>(),
                      readOnly: widget.readOnly,
                    ),
                    CostBody(
                      key: _costKey,
                      onNext: _next,
                      onBack: _back,
                      currentStep: _currentStep,
                      onSaveDraft: _saveDraft,
                      initialCosts:
                          _initialData?['costs'] as Map<String, dynamic>?,
                      engineerCost: _computeEngineerCost(),
                      readOnly: widget.readOnly,
                    ),
                    ReviewBody(
                      onNext: _next,
                      onBack: _back,
                      currentStep: _currentStep,
                      onViewAllContacts: _goToAllContacts,
                      onSaveProject: _saveProject,
                      clientInfo: clientInfo,
                      projectInfo: projectInfo,
                      assignedEngineers: assignedEngineers,
                      costs: costs,
                      projectId: _nextProjectId,
                      readOnly: widget.readOnly,
                    ),
                    BillsBody(
                      key: _billsKey,
                      onBack: _back,
                      onAverageChanged: (avg) =>
                          _projectKey.currentState?.updateAverageBill(avg),
                      initialBills: (_initialData?['projectInfo']
                              as Map<String, dynamic>?)?['bills']
                          ?.cast<Map<String, dynamic>>(),
                      initialAverageBill: ((_initialData?['projectInfo']
                                  as Map<String, dynamic>?)?['averageMonthlyBill']
                              as num?)
                          ?.toDouble(),
                    ), // index 5
                    AllContactPage(
                      onBack: _back,
                      clientInfo: clientInfo,
                      projectId: _nextProjectId,
                    ), // index 6
                  ],
                );
              },
            ),
    );
  }
}
