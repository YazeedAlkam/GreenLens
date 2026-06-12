import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';

/// Read-only review page showing all entered electrical equipment items in tabular form.
///
/// Displayed inside the audit wizard's Review step or from the project summary
/// when the user taps the 'Equipment' drill-down row.
class EquipmentReview extends StatelessWidget {
  final VoidCallback onBack;
  final List<dynamic> equipmentData;

  const EquipmentReview({super.key, required this.onBack, this.equipmentData = const []});

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

  /// Annual energy use of one equipment item in kWh:
  /// rated power (kW) × quantity × yearly operating hours.
  double _computeKwh(Map item) {
    final power = double.tryParse(item['ratedPower']?.toString() ?? '') ?? 0;
    final qty = double.tryParse(item['quantity']?.toString() ?? '') ?? 0;
    final hours = double.tryParse(item['yearlyHours']?.toString() ?? '') ?? 0;
    return power * qty * hours;
  }

  /// Formatted annual energy ("1234 kWh"), or '—' when no data was entered.
  String _totalPower(Map item) {
    final kwh = _computeKwh(item);
    if (kwh == 0) return '—';
    return kwh == kwh.truncateToDouble() ? '${kwh.toInt()} kWh' : '${kwh.toStringAsFixed(2)} kWh';
  }

  /// Annual energy cost = kWh × national tariff (energyTariffJodPerKwh).
  String _energyCost(Map item) {
    final cost = _computeKwh(item) * energyTariffJodPerKwh;
    if (cost == 0) return '—';
    return cost == cost.truncateToDouble() ? '${cost.toInt()} JOD' : '${cost.toStringAsFixed(2)} JOD';
  }

  /// Heading: the item's name, or "Equipment N" when unnamed.
  String _itemTitle(Map item, int index) {
    final name = item['name']?.toString().trim() ?? '';
    return name.isNotEmpty ? name : 'Equipment ${index + 1}';
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
                  ' Equipment Breakdown',
                  style: GoogleFonts.firaSans(fontSize: 40, fontWeight: FontWeight.bold, color: primaryColor),
                ),
              ],
            ),
            Divider(color: dividerColor),
            if (equipmentData.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text('No equipment data entered.', style: GoogleFonts.firaSans(fontSize: 24, color: Colors.grey)),
              )
            else
              ...equipmentData.asMap().entries.map((entry) {
                final i = entry.key;
                final item = entry.value as Map;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_itemTitle(item, i), style: GoogleFonts.firaSans(fontSize: 32, fontWeight: FontWeight.w600, color: primaryColor)),
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
                            _row('Quantity', _v(item, 'quantity')),
                            _row('Rated Power (kW)', _v(item, 'ratedPower', suffix: ' kW')),
                            _row('Usage (Hrs / Year)', _v(item, 'yearlyHours', suffix: ' Hrs')),
                            _row('Total Power (kWh)', _totalPower(item)),
                            _row('Energy Cost (JD)', _energyCost(item)),
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
