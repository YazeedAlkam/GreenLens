import 'package:flutter/material.dart';
import 'package:greenlens/engineer_pages/Equipment_Body.dart';
import 'package:greenlens/engineer_pages/ac_body.dart';
import 'package:greenlens/engineer_pages/building_body.dart';
import 'package:greenlens/engineer_pages/lighting_body.dart';
import 'package:greenlens/engineer_pages/machines_body.dart';
import 'package:greenlens/engineer_pages/shared_files/navbar_eng.dart';
import 'package:greenlens/engineer_pages/shared_files/navbar_eng_title.dart';
import 'package:greenlens/firebase/project_service.dart';
import 'package:greenlens/main.dart';

class Audit_Entery_Flow extends StatefulWidget {
  final String projectId;
  const Audit_Entery_Flow({super.key, required this.projectId});

  @override
  State<Audit_Entery_Flow> createState() => _Audit_Entery_FlowState();
}

class _Audit_Entery_FlowState extends State<Audit_Entery_Flow> {
  int _currentStep = 0;
  Map<String, dynamic>? _projectInfo;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchProject();
  }

  Future<void> _fetchProject() async {
    final data = await ProjectService().getProjectById(widget.projectId);
    setState(() {
      _projectInfo = data?['projectInfo'] as Map<String, dynamic>?;
      _loading = false;
    });
  }

  void _next() {
    if (_currentStep < 5) setState(() => _currentStep++);
  }

  void _back() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  void _onStepTapped(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  //TODO: when make the other pages we uncomment it
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return BuildingBody(
          onNext: _next,
          onBack: _back,
          currentStep: _currentStep,
          projectId: widget.projectId,
          projectInfo: _projectInfo,
        );
      case 1:
        return LightingBody(
          onNext: _next,
          onBack: _back,
          currentStep: _currentStep,
          projectId: widget.projectId,
        );
      case 2:
        return AcBody(
          onNext: _next,
          onBack: _back,
          currentStep: _currentStep,
          projectId: widget.projectId,
        );
      case 3:
        return ElectricalEquipmentBody(
          onNext: _next,
          onBack: _back,
          currentStep: _currentStep,
        );
      case 4:
        return MachinesBody(onNext: _next, onBack: _back, currentStep: _currentStep);
      default:
        return BuildingBody(
          onNext: _next,
          onBack: _back,
          currentStep: _currentStep,
          projectId: widget.projectId,
          projectInfo: _projectInfo,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 200,
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        title: NavBarTitleEng(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                Text(
                  "Step ${_currentStep + 1} of 6",
                  style: const TextStyle(color: Colors.white, fontSize: 26),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 90, right: 90),
                  child: NavigationBarLinesEng(
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
          : _buildCurrentStep(),
    );
  }
}
