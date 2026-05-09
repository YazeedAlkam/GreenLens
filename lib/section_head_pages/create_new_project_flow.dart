import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/section_head_pages/project_info_body.dart';
import 'package:greenlens/section_head_pages/review_body.dart';
import '../main.dart';
import 'all_contacts_body.dart';
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
    if (_showingBills) {
      setState(() => _showingBills = false);
      return;
    }
    if (_showingAllContacts) {
      setState(() => _showingAllContacts = false);
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
        title: NavBarTitle(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                Text(
                  "Step ${_currentStep + 1} of 5",
                  style: GoogleFonts.firaSans(color: Colors.white, fontSize: 26),
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
      body: _showingBills
          ? BillsBody(onBack: _back)
          : _showingAllContacts
          ? AllContactPage(onBack: _back)
          : IndexedStack(
        index: _currentStep,
        children: [
          ClientInfoBody(
            onNext: _next,
            onBack: _back,
            currentStep: _currentStep,
          ),
          ProjectInfoBody(
            onNext: _next,
            onBack: _back,
            currentStep: _currentStep,
            onViewBills: _goToBills,
          ),
          AssignEngBody(
            onNext: _next,
            onBack: _back,
            currentStep: _currentStep,
          ),
          CostBody(
            onNext: _next,
            onBack: _back,
            currentStep: _currentStep,
          ),
          ReviewBody(
            onNext: _next,
            onBack: _back,
            currentStep: _currentStep,
            onViewAllContacts: _goToAllContacts,
          ),
        ],
      ),
    );
  }
}