import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/section_head_pages/assign_engineers/select_engineer_body.dart';
import 'package:greenlens/section_head_pages/assign_engineers/select_project_body.dart';
import 'package:greenlens/section_head_pages/assign_engineers/shared_files/nav_bar.dart';
import 'package:greenlens/section_head_pages/assign_engineers/shared_files/navbar_title.dart';

/// Two-step flow for assigning engineers to an existing project.
///
/// Step 1 — [SelectProjectBody]: choose a project.
/// Step 2 — [SelectEngineerBody]: choose one or more engineers to assign.
class AssignEngineersFlow extends StatefulWidget {
  const AssignEngineersFlow({super.key});

  @override
  State<AssignEngineersFlow> createState() => _AssignEngineersFlowState();
}

/// State for [AssignEngineersFlow]. Tracks the selected project and current step.
class _AssignEngineersFlowState extends State<AssignEngineersFlow> {
  int _currentStep = 0;
  Map<String, dynamic>? _selectedProject;

  /// Stores the chosen project and advances to step 2 (select engineer).
  void _onProjectSelected(Map<String, dynamic> project) {
    setState(() {
      _selectedProject = project;
      _currentStep = 1;
    });
  }

  /// Allows tapping the nav bar to go back to step 0 (select project).
  void _onStepTapped(int step) {
    if (step == 0) setState(() => _currentStep = 0);
  }

  /// Goes back to step 0 or pops the route when already on step 0.
  void _back() {
    if (_currentStep == 0) {
      Navigator.pop(context);
    } else {
      setState(() => _currentStep = 0);
    }
  }

  /// Pops the route after engineers have been successfully saved.
  void _onSaved() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 200,
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        title: const AssignEngNavBarTitle(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                Text(
                  'Step ${_currentStep + 1} of 2',
                  style: GoogleFonts.firaSans(
                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 90, right: 90),
                  child: AssignEngNavBar(
                    currentStep: _currentStep,
                    onStepTapped: _onStepTapped,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _currentStep == 0
          ? SelectProjectBody(
              onProjectSelected: _onProjectSelected,
              onBack: _back,
            )
          : SelectEngineerBody(
              key: ValueKey(_selectedProject?['id']),
              project: _selectedProject!,
              onBack: _back,
              onSaved: _onSaved,
            ),
    );
  }
}
