import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/section_head_pages/create_new_project/shared_files/fotter.dart';

class CostBody extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final Future<void> Function() onSaveDraft;
  final Map<String, dynamic>? initialCosts;

  const CostBody({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    required this.onSaveDraft,
    this.initialCosts,
  });

  @override
  CostBodyState createState() => CostBodyState();
}

class CostBodyState extends State<CostBody> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _transportationCtrl = TextEditingController();
  final _machineryCtrl = TextEditingController();
  final _otherCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final data = widget.initialCosts;
    if (data == null) return;
    _transportationCtrl.text = data['transportationCost'] ?? '';
    _machineryCtrl.text = data['machineryOperatingCost'] ?? '';
    _otherCtrl.text = data['otherCosts'] ?? '';
  }

  @override
  void dispose() {
    _transportationCtrl.dispose();
    _machineryCtrl.dispose();
    _otherCtrl.dispose();
    super.dispose();
  }

  Map<String, dynamic> getCosts() {
    return {
      'transportationCost': _transportationCtrl.text,
      'machineryOperatingCost': _machineryCtrl.text,
      'otherCosts': _otherCtrl.text,
    };
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 30),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Project Costs',
                style: GoogleFonts.firaSans(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const Divider(),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Engineers Expected Cost",
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10, width: double.infinity),
          SizedBox(
            height: 65,
            child: TextField(
              readOnly: true,
              expands: true,
              maxLines: null,
              style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: "No Data",
                filled: true,
                fillColor: disableColor,
                hoverColor: disableColor,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10, width: double.infinity),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Tax",
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10, width: double.infinity),
          SizedBox(
            height: 65,
            child: TextField(
              readOnly: true,
              expands: true,
              maxLines: null,
              style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: "5%",
                filled: true,
                fillColor: disableColor,
                hoverColor: disableColor,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10, width: double.infinity),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Transportation Costs",
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10, width: double.infinity),
          SizedBox(
            height: 65,
            child: TextField(
              controller: _transportationCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: "e.g 100JD",
                filled: true,
                fillColor: Colors.white,
                hoverColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10, width: double.infinity),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Machinery Operating Costs",
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10, width: double.infinity),
          SizedBox(
            height: 65,
            child: TextField(
              controller: _machineryCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: "e.g 30 JOD",
                filled: true,
                fillColor: Colors.white,
                hoverColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10, width: double.infinity),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Other Costs",
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10, width: double.infinity),
          SizedBox(
            height: 65,
            child: TextField(
              controller: _otherCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: "e.g 30 JOD",
                filled: true,
                fillColor: Colors.white,
                hoverColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10, width: double.infinity),
          //TODO: make it auto calculated by the app
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Total Costs",
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10, width: double.infinity),
          SizedBox(
            height: 65,
            child: TextField(
              readOnly: true,
              style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: "----",
                filled: true,
                fillColor: addengColor,
                hoverColor: addengColor,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          CreateNewProjectFooter(
            currentStep: widget.currentStep,
            onNext: widget.onNext,
            onBack: widget.onBack,
            onSaveDraft: widget.onSaveDraft,
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
