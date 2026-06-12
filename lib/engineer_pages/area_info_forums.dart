import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';

/// Form card for entering data for one lighting area.
///
/// Automatically computes total power (kWh) and energy cost (JOD) whenever
/// rated power, number of lights, or yearly hours change. When [readOnly]
/// is true all fields are rendered disabled.
class MainAreaForums extends StatefulWidget {
  final TextEditingController lightingTypeController;
  final TextEditingController ratedPowerController;
  final TextEditingController numLightsController;
  final TextEditingController yearlyHoursController;
  final TextEditingController totalPowerController;
  final TextEditingController energyCostController;
  final bool canDelete;
  final VoidCallback? onDelete;
  final bool readOnly;

  const MainAreaForums({
    super.key,
    required this.lightingTypeController,
    required this.ratedPowerController,
    required this.numLightsController,
    required this.yearlyHoursController,
    required this.totalPowerController,
    required this.energyCostController,
    this.canDelete = false,
    this.onDelete,
    this.readOnly = false,
  });

  @override
  State<MainAreaForums> createState() => _MainAreaForumsState();
}

/// State for [MainAreaForums]. Registers listeners to auto-calculate totals.
class _MainAreaForumsState extends State<MainAreaForums> {
  /// Computes total energy (kWh/yr) and cost (JOD/yr) from the form inputs
  /// and writes the results back into the read-only display controllers.
  void _recalculate() {
    final ratedW = double.tryParse(widget.ratedPowerController.text) ?? 0;
    final numLights = double.tryParse(widget.numLightsController.text) ?? 0;
    final hours = double.tryParse(widget.yearlyHoursController.text) ?? 0;

    final totalKwh = (ratedW / 1000) * numLights * hours;
    final energyCost = totalKwh * energyTariffJodPerKwh;

    widget.totalPowerController.text =
        (totalKwh > 0) ? totalKwh.toStringAsFixed(2) : '';
    widget.energyCostController.text =
        (energyCost > 0) ? energyCost.toStringAsFixed(2) : '';
  }

  @override
  void initState() {
    super.initState();
    widget.ratedPowerController.addListener(_recalculate);
    widget.numLightsController.addListener(_recalculate);
    widget.yearlyHoursController.addListener(_recalculate);
  }

  @override
  void dispose() {
    widget.ratedPowerController.removeListener(_recalculate);
    widget.numLightsController.removeListener(_recalculate);
    widget.yearlyHoursController.removeListener(_recalculate);
    super.dispose();
  }

  /// Returns a consistent [InputDecoration] for all form fields.
  ///
  /// When [readOnly] is true the field is filled with [disableColor].
  InputDecoration _fieldDecoration(String hint, {bool readOnly = false}) => InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.firaSans(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF808080),
    ),
    filled: readOnly,
    fillColor: disableColor,
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 2, color: Color(0xFF808080)),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 2, color: Color(0xFF808080)),
      borderRadius: BorderRadius.circular(12),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black, width: 2),
      ),
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Lighting Type',
                      style: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '*',
                      style: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: deniedColor,
                      ),
                    ),
                  ],
                ),
                if (!widget.readOnly && widget.canDelete && widget.onDelete != null)
                  GestureDetector(
                    onTap: widget.onDelete,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEDED),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Delete Area',
                        style: GoogleFonts.firaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 65,
              child: TextField(
                controller: widget.lightingTypeController,
                readOnly: widget.readOnly,
                expands: true,
                maxLines: null,
                style: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                decoration: _fieldDecoration('e.g Fluorescent', readOnly: widget.readOnly),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'Rated Power (W)',
                        style: GoogleFonts.firaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '*',
                        style: GoogleFonts.firaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: deniedColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'No. of Lights',
                        style: GoogleFonts.firaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '*',
                        style: GoogleFonts.firaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: deniedColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 65,
                    child: TextField(
                      controller: widget.ratedPowerController,
                      readOnly: widget.readOnly,
                      expands: true,
                      maxLines: null,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: _fieldDecoration('e.g 36', readOnly: widget.readOnly),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 65,
                    child: TextField(
                      controller: widget.numLightsController,
                      readOnly: widget.readOnly,
                      expands: true,
                      maxLines: null,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: _fieldDecoration('e.g 120', readOnly: widget.readOnly),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Text(
                  'Yearly Operating Hours',
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '*',
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: deniedColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 65,
              child: TextField(
                controller: widget.yearlyHoursController,
                readOnly: widget.readOnly,
                expands: true,
                maxLines: null,
                keyboardType: TextInputType.number,
                style: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                decoration: _fieldDecoration('e.g 1200', readOnly: widget.readOnly),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'Total Power (kW)',
                        style: GoogleFonts.firaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '*',
                        style: GoogleFonts.firaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: readyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'Energy Cost (JD)',
                        style: GoogleFonts.firaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '*',
                        style: GoogleFonts.firaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: readyColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 65,
                    child: TextField(
                      controller: widget.totalPowerController,
                      readOnly: true,
                      expands: true,
                      maxLines: null,
                      style: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: _fieldDecoration('----').copyWith(
                        filled: true,
                        fillColor: const Color(0xFFe8f5e9),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 65,
                    child: TextField(
                      controller: widget.energyCostController,
                      readOnly: true,
                      expands: true,
                      maxLines: null,
                      style: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: _fieldDecoration('----').copyWith(
                        filled: true,
                        fillColor: const Color(0xFFe8f5e9),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
