import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainAreaForums extends StatelessWidget {
  final TextEditingController lightingTypeController;
  final TextEditingController ratedPowerController;
  final TextEditingController numLightsController;
  final TextEditingController yearlyHoursController;
  final TextEditingController totalPowerController;
  final TextEditingController annualController;

  const MainAreaForums({
    super.key,
    required this.lightingTypeController,
    required this.ratedPowerController,
    required this.numLightsController,
    required this.yearlyHoursController,
    required this.totalPowerController,
    required this.annualController,
  });

  InputDecoration _fieldDecoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.firaSans(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF808080),
    ),
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
            Text(
              'Lighting Type',
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 65,
              child: TextField(
                controller: lightingTypeController,
                expands: true,
                maxLines: null,
                style: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                decoration: _fieldDecoration('e.g Fluorescent'),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Text(
                  'Rated Power (W)',
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 336),
                Text(
                  'No. of Lights',
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
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
                      controller: ratedPowerController,
                      expands: true,
                      maxLines: null,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: _fieldDecoration('e.g 36'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 65,
                    child: TextField(
                      controller: numLightsController,
                      expands: true,
                      maxLines: null,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: _fieldDecoration('e.g 120'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              'Yearly Operating Hours',
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 65,
              child: TextField(
                controller: yearlyHoursController,
                expands: true,
                maxLines: null,
                keyboardType: TextInputType.number,
                style: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                decoration: _fieldDecoration('e.g 1200'),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Text(
                  'Total Power (kW)',
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 336),
                Text(
                  'Annual (kW/yr)',
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
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
                      controller: totalPowerController,
                      readOnly: true,
                      expands: true,
                      maxLines: null,
                      style: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: _fieldDecoration('----'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 65,
                    child: TextField(
                      controller: annualController,
                      readOnly: true,
                      expands: true,
                      maxLines: null,
                      style: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: _fieldDecoration('----'),
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
