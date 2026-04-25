import 'package:flutter/material.dart';
import 'package:greenlens/section_head_pages/project_info_body.dart';

import '../main.dart';
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

  void _next() {
    if (_currentStep < 3) setState(() => _currentStep++);
  }

  void _back() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context); // back to dashboard
    }
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0: return ClientInfoBody(onNext: _next, onBack: _back, currentStep: _currentStep);
      case 1: return ProjectInfoBody(onNext: _next, onBack: _back, currentStep: _currentStep);
      //case 2: return Step3Body(onNext: _next, onBack: _back, currentStep: _currentStep);
      //case 3: return Step4Body(onNext: _next, onBack: _back, currentStep: _currentStep);
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
                  "Step ${_currentStep + 1} of 4",
                  style: const TextStyle(color: Colors.white, fontSize: 26),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 90, right: 40),
                  child: NavigationBarLines(
                    currentStep: _currentStep,
                    onStepTapped: (step) => setState(() => _currentStep = step),
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