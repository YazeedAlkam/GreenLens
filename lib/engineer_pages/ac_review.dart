import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';

/// Read-only review page showing all entered AC/HVAC groups in tabular form.
///
/// Displayed inside the audit wizard's Review step or from the project summary
/// when the user taps the 'HVAC' drill-down row.
class AcReview extends StatelessWidget {
  final VoidCallback onBack;
  final List<dynamic> acData;

  const AcReview({super.key, required this.onBack, this.acData = const []});

  /// Safe value accessor: returns [map][key] with optional [suffix], or '—' if absent.
  String _v(Map map, String key, {String suffix = ''}) {
    final val = map[key]?.toString() ?? '';
    return val.isEmpty ? '—' : '$val$suffix';
  }

  /// Builds a two-cell table row (label | value) for the data tables.
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

  /// Annual energy use of one AC group in kWh. The formula depends on the
  /// AC type selected in the entry form:
  ///   Split (0):    units × rated power (kW) × yearly hours
  ///   Packaged (1): packages × package power (kW) × yearly hours
  ///   Central (2):  chiller power (kW) × yearly hours (single chiller)
  double _computeKwh(Map g) {
    final acType = g['acType'] as int? ?? 0;
    if (acType == 0) {
      final units = double.tryParse(g['noOfUnits']?.toString() ?? '') ?? 0;
      final power = double.tryParse(g['ratedPower']?.toString() ?? '') ?? 0;
      final hours = double.tryParse(g['yearlyHours']?.toString() ?? '') ?? 0;
      return units * power * hours;
    } else if (acType == 1) {
      final units = double.tryParse(g['noOfPackages']?.toString() ?? '') ?? 0;
      final power = double.tryParse(g['packagePower']?.toString() ?? '') ?? 0;
      final hours = double.tryParse(g['packageHours']?.toString() ?? '') ?? 0;
      return units * power * hours;
    } else {
      final power = double.tryParse(g['chillerPower']?.toString() ?? '') ?? 0;
      final hours = double.tryParse(g['chillerHours']?.toString() ?? '') ?? 0;
      return power * hours;
    }
  }

  /// Formatted annual energy ("1234 kWh"), or '—' when no data was entered.
  String _totalPower(Map g) {
    final kwh = _computeKwh(g);
    if (kwh == 0) return '—';
    return kwh == kwh.truncateToDouble() ? '${kwh.toInt()} kWh' : '${kwh.toStringAsFixed(2)} kWh';
  }

  /// Annual energy cost = kWh × national tariff (energyTariffJodPerKwh).
  String _energyCost(Map g) {
    final cost = _computeKwh(g) * energyTariffJodPerKwh;
    if (cost == 0) return '—';
    return cost == cost.truncateToDouble() ? '${cost.toInt()} JOD' : '${cost.toStringAsFixed(2)} JOD';
  }

  /// Table rows for one group — the field set varies with the AC type
  /// (split / packaged / central) chosen in the entry form.
  List<TableRow> _groupRows(Map g) {
    final acType = g['acType'] as int? ?? 0;
    if (acType == 0) {
      return [
        _row('No. of Units', _v(g, 'noOfUnits')),
        _row('Capacity (TR)', _v(g, 'capacity', suffix: ' TR')),
        _row('Rated Power (kW)', _v(g, 'ratedPower', suffix: ' kW')),
        _row('Usage (Hrs / Year)', _v(g, 'yearlyHours', suffix: ' Hrs')),
        _row('Total Power (kWh)', _totalPower(g)),
        _row('Energy Cost (JD)', _energyCost(g)),
      ];
    } else if (acType == 1) {
      return [
        _row('No. of Packages', _v(g, 'noOfPackages')),
        _row('Package Capacity (TR)', _v(g, 'packageCapacity', suffix: ' TR')),
        _row('Package Power (kW)', _v(g, 'packagePower', suffix: ' kW')),
        _row('Usage (Hrs / Year)', _v(g, 'packageHours', suffix: ' Hrs')),
        _row('Total Power (kWh)', _totalPower(g)),
        _row('Energy Cost (JD)', _energyCost(g)),
      ];
    } else {
      return [
        _row('Chiller Capacity (TR)', _v(g, 'chillerCapacity', suffix: ' TR')),
        _row('Chiller Power (kW)', _v(g, 'chillerPower', suffix: ' kW')),
        _row('Usage (Hrs / Year)', _v(g, 'chillerHours', suffix: ' Hrs')),
        _row('Total Power (kWh)', _totalPower(g)),
        _row('Energy Cost (JD)', _energyCost(g)),
      ];
    }
  }

  /// Heading like "Group 1 – Split / Inverter", built from the stored
  /// acType and invertor toggle indexes.
  String _groupTitle(Map g, int index) {
    final acType = g['acType'] as int? ?? 0;
    final invertor = g['invertor'] as int? ?? 0;
    if (acType == 0) {
      final sub = invertor == 0 ? 'Inverter' : 'Non-Invertor';
      return 'Group ${index + 1} – Split / $sub';
    } else if (acType == 1) {
      return 'Group ${index + 1} – Packaged';
    } else {
      final sub = invertor == 0 ? 'Air Cooler' : 'Water Cooler';
      return 'Group ${index + 1} – Central / $sub';
    }
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
                  ' AC Breakdown',
                  style: GoogleFonts.firaSans(fontSize: 40, fontWeight: FontWeight.bold, color: primaryColor),
                ),
              ],
            ),
            Divider(color: dividerColor),
            if (acData.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text('No AC data entered.', style: GoogleFonts.firaSans(fontSize: 24, color: Colors.grey)),
              )
            else
              ...acData.asMap().entries.map((entry) {
                final i = entry.key;
                final g = entry.value as Map;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_groupTitle(g, i), style: GoogleFonts.firaSans(fontSize: 32, fontWeight: FontWeight.w600, color: primaryColor)),
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
                          children: _groupRows(g),
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
