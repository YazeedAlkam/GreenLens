import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/shared_files/footer.dart';

/// Step 4 of the Create Project wizard: study cost entry.
///
/// Captures transportation, machinery operating, and other costs.
/// The engineer cost is pre-calculated from Firestore and displayed read-only.
class CostBody extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final Future<void> Function() onSaveDraft;
  final Map<String, dynamic>? initialCosts;
  final double? engineerCost;
  final bool readOnly;

  const CostBody({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    required this.onSaveDraft,
    this.initialCosts,
    this.engineerCost,
    this.readOnly = false,
  });

  @override
  CostBodyState createState() => CostBodyState();
}

/// State for [CostBody]. Exposes [getCosts] via [GlobalKey].
class CostBodyState extends State<CostBody> with AutomaticKeepAliveClientMixin {
  // Keep form state alive when the wizard swaps steps.
  @override
  bool get wantKeepAlive => true;

  final _transportationCtrl = TextEditingController();
  final _machineryCtrl = TextEditingController();
  final _otherCtrl = TextEditingController();
  final _engineerCostCtrl = TextEditingController();
  final _totalCostCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final data = widget.initialCosts;
    if (data != null) {
      _transportationCtrl.text = data['transportationCost'] ?? '';
      _machineryCtrl.text = data['machineryOperatingCost'] ?? '';
      _otherCtrl.text = data['otherCosts'] ?? '';
    }
    _transportationCtrl.addListener(_recompute);
    _machineryCtrl.addListener(_recompute);
    _otherCtrl.addListener(_recompute);
    _syncEngineerCost();
    _recompute();
  }

  // The engineer cost is computed by the parent (sum of assigned engineers'
  // rates), so refresh the read-only field whenever the parent passes a
  // new value (e.g. after engineers were added/removed in step 3).
  @override
  void didUpdateWidget(CostBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.engineerCost != widget.engineerCost) {
      _syncEngineerCost();
      _recompute();
    }
  }

  /// Writes the engineer cost into its read-only field, dropping the
  /// decimals when the value is a whole number (e.g. "150" not "150.00").
  void _syncEngineerCost() {
    final e = widget.engineerCost;
    _engineerCostCtrl.text = e == null
        ? ''
        : (e == e.truncateToDouble()
            ? e.toInt().toString()
            : e.toStringAsFixed(2));
  }

  /// Recomputes Total = transportation + machinery + other + engineer cost.
  /// Shows an empty total until at least one cost has been entered.
  void _recompute() {
    final t = double.tryParse(_transportationCtrl.text) ?? 0;
    final m = double.tryParse(_machineryCtrl.text) ?? 0;
    final o = double.tryParse(_otherCtrl.text) ?? 0;
    final e = widget.engineerCost ?? 0;
    final hasData = _transportationCtrl.text.isNotEmpty ||
        _machineryCtrl.text.isNotEmpty ||
        _otherCtrl.text.isNotEmpty ||
        widget.engineerCost != null;
    if (!hasData) {
      _totalCostCtrl.text = '';
      return;
    }
    final total = t + m + o + e;
    _totalCostCtrl.text = total == total.truncateToDouble()
        ? total.toInt().toString()
        : total.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _transportationCtrl.removeListener(_recompute);
    _machineryCtrl.removeListener(_recompute);
    _otherCtrl.removeListener(_recompute);
    _transportationCtrl.dispose();
    _machineryCtrl.dispose();
    _otherCtrl.dispose();
    _engineerCostCtrl.dispose();
    _totalCostCtrl.dispose();
    super.dispose();
  }

  /// Returns the editable cost fields as the `costs` map saved to Firestore
  /// (engineer cost and total are derived, so they are not stored here).
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
              controller: _engineerCostCtrl,
              readOnly: true,
              expands: true,
              maxLines: null,
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
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
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
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
              readOnly: widget.readOnly,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: "e.g 100JD",
                filled: true,
                fillColor: widget.readOnly ? disableColor : Colors.white,
                hoverColor: widget.readOnly ? disableColor : Colors.white,
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
              readOnly: widget.readOnly,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: "e.g 30 JOD",
                filled: true,
                fillColor: widget.readOnly ? disableColor : Colors.white,
                hoverColor: widget.readOnly ? disableColor : Colors.white,
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
              readOnly: widget.readOnly,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: "e.g 30 JOD",
                filled: true,
                fillColor: widget.readOnly ? disableColor : Colors.white,
                hoverColor: widget.readOnly ? disableColor : Colors.white,
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
              controller: _totalCostCtrl,
              readOnly: true,
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
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
          Footer(
            currentStep: widget.currentStep,
            onNext: widget.onNext,
            onBack: widget.onBack,
            onSaveDraft: widget.onSaveDraft,
            mode: widget.readOnly ? FooterMode.viewOnly : FooterMode.normal,
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
