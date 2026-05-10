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

class CreateProjectFlow extends StatefulWidget {
  final String? existingProjectId;
  final bool readOnly;
  const CreateProjectFlow({super.key, this.existingProjectId, this.readOnly = false});

  @override
  State<CreateProjectFlow> createState() => _CreateProjectFlowState();
}

class _CreateProjectFlowState extends State<CreateProjectFlow> {
  final _projectService = ProjectService();
  String? _projectId;
  String _nextProjectId = '';
  bool _loading = false;
  Map<String, dynamic>? _initialData;

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

  Map<String, dynamic> _mergedProjectInfo() {
    return {
      ...?_projectKey.currentState?.getProjectInfo(),
      ...?_billsKey.currentState?.getBillsData(),
    };
  }

  Future<void> _saveDraft() async {
    _projectId = await _projectService.saveProject(
      existingProjectId: _projectId,
      status: 'draft',
      clientInfo: _clientKey.currentState?.getClientInfo() ?? {},
      projectInfo: _mergedProjectInfo(),
      assignedEngineers: _assignKey.currentState?.getAssignedEngineers() ?? [],
      costs: _costKey.currentState?.getCosts() ?? {},
    );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _saveProject() async {
    _projectId = await _projectService.saveProject(
      existingProjectId: _projectId,
      status: 'Awaiting Approval',
      clientInfo: _clientKey.currentState?.getClientInfo() ?? {},
      projectInfo: _mergedProjectInfo(),
      assignedEngineers: _assignKey.currentState?.getAssignedEngineers() ?? [],
      costs: _costKey.currentState?.getCosts() ?? {},
    );
    if (mounted) Navigator.pop(context);
  }

  int _currentStep = 0;
  bool _showingBills = false;
  bool _showingAllContacts = false;

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

  void _goToBills() => setState(() => _showingBills = true);

  void _goToAllContacts() => setState(() => _showingAllContacts = true);

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
