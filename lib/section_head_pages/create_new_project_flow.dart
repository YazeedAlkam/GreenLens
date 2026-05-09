import 'package:flutter/material.dart';
import 'package:greenlens/section_head_pages/project_info_body.dart';
import 'package:greenlens/section_head_pages/review_body.dart';
import '../main.dart';
import 'allcontact_page.dart';
import 'assign_eng_body.dart';
import 'bills_body.dart';
import 'cost_body.dart';
import 'shared_files/nav_bar.dart';
import 'client_info_body.dart';
import 'shared_files/navbar_title.dart';

class CreateProjectFlow extends StatefulWidget {
  const CreateProjectFlow({super.key});

  @override
  State<CreateProjectFlow> createState() => _CreateProjectFlowState();
}

class _CreateProjectFlowState extends State<CreateProjectFlow> {
  int _currentStep = 0;
  bool _showingBills = false;
  bool _showingAllContacts = false;

  void _next() {
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

  void _goToBills() {
    setState(() => _showingBills = true);
  }

  void _goToAllContacts() {
    setState(() => _showingAllContacts = true);
  }

  void _onStepTapped(int step) {
    setState(() {
      _currentStep = step;
      _showingBills = false; // ← exit bills view if user taps a step
    });
  }

  Widget _buildCurrentStep() {
    if (_showingBills) {
      return BillsBody(onBack: _back);
    }
    if (_showingAllContacts) {
      return AllContactPage(onBack: _back);
    }

    switch (_currentStep) {
      case 0: return ClientInfoBody(onNext: _next, onBack: _back, currentStep: _currentStep);
      case 1: return ProjectInfoBody(onNext: _next, onBack: _back, currentStep: _currentStep, onViewBills: _goToBills,);
      case 2: return AssignEngBody(onNext: _next, onBack: _back, currentStep: _currentStep);
      case 3: return CostBody(onNext: _next, onBack: _back, currentStep: _currentStep);
      case 4: return ReviewBody(onNext: _next, onBack: _back, currentStep: _currentStep, onViewAllContacts: _goToAllContacts,);
      default: return ClientInfoBody(onNext: _next, onBack: _back, currentStep: _currentStep);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 200,
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        title: NavBarTitle(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                Text(
                  "Step ${_currentStep + 1} of 5",
                  style: const TextStyle(color: Colors.white, fontSize: 26),
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
      body: _buildCurrentStep(),
    );
  }
}