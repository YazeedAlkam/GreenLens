import 'package:flutter/material.dart';
import 'package:greenlens/engineer_pages/equipment_body.dart';
import 'package:greenlens/engineer_pages/ac_body.dart';
import 'package:greenlens/engineer_pages/ac_review.dart';
import 'package:greenlens/engineer_pages/building_body.dart';
import 'package:greenlens/engineer_pages/equipment_review.dart';
import 'package:greenlens/engineer_pages/lighting_body.dart';
import 'package:greenlens/engineer_pages/lighting_review.dart';
import 'package:greenlens/engineer_pages/machines_body.dart';
import 'package:greenlens/engineer_pages/production_review.dart';
import 'package:greenlens/engineer_pages/review_eng.dart';
import 'package:greenlens/engineer_pages/shared_files/navbar_eng.dart';
import 'package:greenlens/engineer_pages/shared_files/navbar_eng_title.dart';
import 'package:greenlens/firebase/project_service.dart';
import 'package:greenlens/main.dart';

class AuditEntryFlow extends StatefulWidget {
  final String projectId;
  final bool readOnly;
  const AuditEntryFlow({super.key, required this.projectId, this.readOnly = false});

  @override
  State<AuditEntryFlow> createState() => _AuditEntryFlowState();
}

class _AuditEntryFlowState extends State<AuditEntryFlow> {
  int _currentStep = 0;
  int? _reviewDetail; // 0=lighting 1=ac 2=equipment 3=machines
  Map<String, dynamic>? _projectInfo;
  Map<String, dynamic>? _auditData;
  bool _loading = true;

  final _buildingKey = GlobalKey<BuildingBodyState>();
  final _lightingKey = GlobalKey<LightingBodyState>();
  final _acKey = GlobalKey<AcBodyState>();
  final _equipmentKey = GlobalKey<ElectricalEquipmentBodyState>();
  final _machinesKey = GlobalKey<MachinesBodyState>();

  @override
  void initState() {
    super.initState();
    _fetchProject();
  }

  Future<void> _fetchProject() async {
    final data = await ProjectService().getProjectById(widget.projectId);
    setState(() {
      _projectInfo = data?['projectInfo'] as Map<String, dynamic>?;
      _auditData = data?['auditData'] as Map<String, dynamic>?;
      _loading = false;
    });
  }

  Future<void> _save() async {
    try {
      await ProjectService().updateFields(widget.projectId, {
        'auditData.building': _buildingKey.currentState?.getBuildingAuditData() ?? {},
        'auditData.lighting': _lightingKey.currentState?.getLightingData() ?? [],
        'auditData.ac': _acKey.currentState?.getAcData() ?? [],
        'auditData.equipment': _equipmentKey.currentState?.getEquipmentData() ?? [],
        'auditData.machines': _machinesKey.currentState?.getMachinesData() ?? [],
        'projectInfo.salesMark': _buildingKey.currentState?.getSalesMark() ?? '',
      });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save failed: $e')),
        );
      }
    }
  }

  void _next() {
    if (_currentStep < 5) setState(() => _currentStep++);
  }

  void _back() {
    if (_reviewDetail != null) {
      setState(() => _reviewDetail = null);
      return;
    }
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  void _onStepTapped(int step) {
    setState(() {
      _currentStep = step;
      _reviewDetail = null;
    });
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
          : Builder(
              builder: (context) {
                final lightingData = _lightingKey.currentState?.getLightingData() ?? [];
                final acData = _acKey.currentState?.getAcData() ?? [];
                final equipmentData = _equipmentKey.currentState?.getEquipmentData() ?? [];
                final machinesData = _machinesKey.currentState?.getMachinesData() ?? [];

                return IndexedStack(
                  index: _reviewDetail != null ? 6 + _reviewDetail! : _currentStep,
                  children: [
                    BuildingBody(
                      key: _buildingKey,
                      onNext: _next,
                      onBack: _back,
                      currentStep: _currentStep,
                      projectInfo: _projectInfo,
                      auditBuildingData: _auditData?['building'] as Map<String, dynamic>?,
                      onSaveDraft: _save,
                      readOnly: widget.readOnly,
                    ),
                    LightingBody(
                      key: _lightingKey,
                      onNext: _next,
                      onBack: _back,
                      currentStep: _currentStep,
                      auditLightingData: _auditData?['lighting'] as List<dynamic>?,
                      onSaveDraft: _save,
                      readOnly: widget.readOnly,
                    ),
                    AcBody(
                      key: _acKey,
                      onNext: _next,
                      onBack: _back,
                      currentStep: _currentStep,
                      auditAcData: _auditData?['ac'] as List<dynamic>?,
                      onSaveDraft: _save,
                      readOnly: widget.readOnly,
                    ),
                    ElectricalEquipmentBody(
                      key: _equipmentKey,
                      onNext: _next,
                      onBack: _back,
                      currentStep: _currentStep,
                      auditEquipmentData: _auditData?['equipment'] as List<dynamic>?,
                      onSaveDraft: _save,
                      readOnly: widget.readOnly,
                    ),
                    MachinesBody(
                      key: _machinesKey,
                      onNext: _next,
                      onBack: _back,
                      currentStep: _currentStep,
                      auditMachinesData: _auditData?['machines'] as List<dynamic>?,
                      onSaveDraft: _save,
                      readOnly: widget.readOnly,
                    ),
                    ReviewBodyEng(
                      onBack: _back,
                      currentStep: _currentStep,
                      onSave: _save,
                      projectInfo: _projectInfo,
                      lightingData: lightingData,
                      acData: acData,
                      equipmentData: equipmentData,
                      machinesData: machinesData,
                      onViewLighting: () => setState(() => _reviewDetail = 0),
                      onViewAC: () => setState(() => _reviewDetail = 1),
                      onViewEquipment: () => setState(() => _reviewDetail = 2),
                      onViewMachines: () => setState(() => _reviewDetail = 3),
                      readOnly: widget.readOnly,
                    ),
                    LightingReview(onBack: _back, lightingData: lightingData),
                    AcReview(onBack: _back, acData: acData),
                    EquipmentReview(onBack: _back, equipmentData: equipmentData),
                    ProductionReview(onBack: _back, machinesData: machinesData),
                  ],
                );
              },
            ),
    );
  }
}
