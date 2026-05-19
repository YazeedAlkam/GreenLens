import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';

class LightingReview extends StatelessWidget {
  final VoidCallback onBack;
  final List<dynamic> lightingData;

  const LightingReview({super.key, required this.onBack, this.lightingData = const []});

  String _v(Map map, String key, {String suffix = ''}) {
    final val = map[key]?.toString() ?? '';
    return val.isEmpty ? '—' : '$val$suffix';
  }

  TableRow _row(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Text(label, style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.black)),
              const Spacer(),
              Text(value, style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.black)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 30, 32, 0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: onBack,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: SvgPicture.asset('assets/images/Left Arrow.svg'),
                ),
                Text(
                  ' Lighting Breakdown',
                  style: GoogleFonts.firaSans(fontSize: 40, fontWeight: FontWeight.bold, color: primaryColor),
                ),
              ],
            ),
            Divider(color: dividerColor),
            if (lightingData.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text('No lighting data entered.', style: GoogleFonts.firaSans(fontSize: 24, color: Colors.grey)),
              )
            else
              ...lightingData.asMap().entries.map((entry) {
                final i = entry.key;
                final area = entry.value as Map;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Area ${i + 1}', style: GoogleFonts.firaSans(fontSize: 32, fontWeight: FontWeight.w600, color: primaryColor)),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: tablelinescolor, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Table(
                          border: TableBorder.symmetric(inside: BorderSide(color: tablelinescolor, width: 2)),
                          children: [
                            _row('Type', _v(area, 'lightingType')),
                            _row('No of lights', _v(area, 'numLights')),
                            _row('Rated Power', _v(area, 'ratedPower', suffix: ' W')),
                            _row('Usage (Hrs / Year)', _v(area, 'yearlyHours', suffix: ' Hrs')),
                            _row('Total kWh / Year', _v(area, 'annual', suffix: ' kWh')),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
