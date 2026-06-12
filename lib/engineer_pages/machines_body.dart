import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
import '../shared_files/footer.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data model for one equipment item
// ─────────────────────────────────────────────────────────────────────────────
/// Data model and controller holder for one production-line machine item.
///
/// Mirrors [EquipmentItem] but is used for the Machines / Production Lines step.
class MachineItem {
  int id; // ← not final anymore so we can reassign after remove
  bool isCompressedAir;
  final TextEditingController nameController;
  final TextEditingController compressedAirTypeController;
  final TextEditingController ratedPowerController;
  final TextEditingController quantityController;
  final TextEditingController yearlyHoursController;

  MachineItem({required this.id})
    : isCompressedAir = false,
      nameController = TextEditingController(),
      compressedAirTypeController = TextEditingController(),
      ratedPowerController = TextEditingController(),
      quantityController = TextEditingController(),
      yearlyHoursController = TextEditingController();

  /// Label shown on the item's tab. Priority: typed name → "Compressed Air" → "Production Line N".
  String get tabLabel {
    final name = nameController.text.trim();
    if (name.isNotEmpty) return name;
    if (isCompressedAir) return 'Compressed Air';
    return 'Production Line $id';
  }

  /// Yearly energy consumption in kWh: ratedPower × quantity × yearlyHours.
  double get totalPower {
    final power = double.tryParse(ratedPowerController.text) ?? 0;
    final qty = double.tryParse(quantityController.text) ?? 0;
    final hours = double.tryParse(yearlyHoursController.text) ?? 0;
    return power * qty * hours;
  }

  /// Annual energy cost in JOD: [totalPower] × [energyTariffJodPerKwh].
  double get energyCost {
    return totalPower * energyTariffJodPerKwh;
  }

  /// Serialises the item to a Firestore-friendly map.
  Map<String, dynamic> toMap() => {
    'id': id,
    'isCompressedAir': isCompressedAir,
    'name': nameController.text,
    'compressedAirType': compressedAirTypeController.text,
    'ratedPower': ratedPowerController.text,
    'quantity': quantityController.text,
    'yearlyHours': yearlyHoursController.text,
    'energyCost': energyCost > 0 ? energyCost.toStringAsFixed(2) : '',
  };

  /// Deserialises a [MachineItem] from a Firestore map.
  static MachineItem fromMap(Map<String, dynamic> map) {
    final item = MachineItem(id: (map['id'] as int?) ?? 1);
    item.isCompressedAir = (map['isCompressedAir'] as bool?) ?? false;
    item.nameController.text = map['name']?.toString() ?? '';
    item.compressedAirTypeController.text = map['compressedAirType']?.toString() ?? '';
    item.ratedPowerController.text = map['ratedPower']?.toString() ?? '';
    item.quantityController.text = map['quantity']?.toString() ?? '';
    item.yearlyHoursController.text = map['yearlyHours']?.toString() ?? '';
    return item;
  }

  void dispose() {
    nameController.dispose();
    compressedAirTypeController.dispose();
    ratedPowerController.dispose();
    quantityController.dispose();
    yearlyHoursController.dispose();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Main page widget
// ─────────────────────────────────────────────────────────────────────────────
/// Step 5 of the audit entry wizard: production-line machines data entry.
///
/// Each machine/line has its own tab. When [readOnly] is true all fields are disabled.
class MachinesBody extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final bool readOnly;
  final List<dynamic>? auditMachinesData;
  final Future<void> Function()? onSaveDraft;

  const MachinesBody({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    this.readOnly = false,
    this.auditMachinesData,
    this.onSaveDraft,
  });

  @override
  State<MachinesBody> createState() => MachinesBodyState();
}

/// State for [MachinesBody]. Manages the [MachineItem] list and exposes
/// [getMachinesData] for the parent wizard via a [GlobalKey].
class MachinesBodyState extends State<MachinesBody> {
  final List<MachineItem> _items = [MachineItem(id: 1)];
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    final saved = widget.auditMachinesData;
    if (saved == null || saved.isEmpty) return;
    _items.clear();
    for (final map in saved) {
      _items.add(MachineItem.fromMap(map as Map<String, dynamic>));
    }
    _reassignIds();
  }

  /// Returns all machine items serialised to maps, stored under
  /// `auditData.machines` in Firestore.
  List<Map<String, dynamic>> getMachinesData() =>
      _items.map((i) => i.toMap()).toList();

  /// Re-numbers item IDs as 1, 2, 3… after an add or remove operation.
  void _reassignIds() {
    for (int i = 0; i < _items.length; i++) {
      _items[i].id = i + 1;
    }
  }

  /// Appends a new [MachineItem] and switches to its tab.
  void _addItem() {
    setState(() {
      _items.add(MachineItem(id: _items.length + 1));
      _reassignIds();
      _activeIndex = _items.length - 1;
    });
  }

  /// Removes the item at [index], disposes its controllers, and resets IDs.
  /// Does nothing when only one item remains.
  void _removeItem(int index) {
    if (_items.length == 1) return;
    setState(() {
      _items[index].dispose();
      _items.removeAt(index);
      _reassignIds(); // ← close the gap
      if (_activeIndex >= _items.length) {
        _activeIndex = _items.length - 1;
      }
    });
  }

  @override
  void dispose() {
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 30, 32, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Production Lines",
              style: GoogleFonts.firaSans(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: dividerColor, height: 2, thickness: 2),
            const SizedBox(height: 16),

            // ── Tabs row ────────────────────────────────────────────────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ..._items.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final item = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(right: 18),
                      child: _MachineTabButton(
                        label: item.tabLabel,
                        isActive: _activeIndex == idx,
                        onTap: () => setState(() => _activeIndex = idx),
                      ),
                    );
                  }),
                  if (!widget.readOnly) _AddTabButton(onTap: _addItem),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Active form ─────────────────────────────────────────────────
            if (_items.isNotEmpty)
              MachineForm(
                key: ValueKey(_items[_activeIndex].id),
                item: _items[_activeIndex],
                readOnly: widget.readOnly,
                canRemove: _items.length > 1,
                onRemove: () => _removeItem(_activeIndex),
                onChanged: () =>
                    setState(() {}), // ← rebuilds tabs on name change
              ),

            const SizedBox(height: 16),

            // ── Footer ──────────────────────────────────────────────────────
            Footer(
              currentStep: widget.currentStep,
              onNext: widget.onNext,
              onBack: widget.onBack,
              mode: widget.readOnly ? FooterMode.viewOnly : FooterMode.auditNormal,
              onSaveDraft: widget.onSaveDraft,
            ),
            const SizedBox(height: 10000),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Single equipment form card
// ─────────────────────────────────────────────────────────────────────────────
/// Form card for editing or viewing a single [MachineItem].
///
/// Listens to rated-power, quantity, and yearly-hours controllers to
/// reactively recompute the displayed total power and energy cost.
class MachineForm extends StatefulWidget {
  final MachineItem item;
  final bool readOnly;
  final bool canRemove;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  const MachineForm({
    super.key,
    required this.item,
    required this.readOnly,
    required this.canRemove,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  State<MachineForm> createState() => _MachineFormState();
}

/// State for [MachineForm].
class _MachineFormState extends State<MachineForm> {
  MachineItem get _item => widget.item;

  /// Triggers a rebuild so the computed total power/cost fields update.
  void _recalculate() => setState(() {});

  /// Triggers [widget.onChanged] so the parent can rebuild the tab label.
  void _onNameChanged() => widget.onChanged();

  @override
  void initState() {
    super.initState();

    _item.ratedPowerController.addListener(_recalculate);
    _item.quantityController.addListener(_recalculate);
    _item.yearlyHoursController.addListener(_recalculate);
    _item.nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _item.ratedPowerController.removeListener(_recalculate);
    _item.quantityController.removeListener(_recalculate);
    _item.yearlyHoursController.removeListener(_recalculate);
    _item.nameController.removeListener(_onNameChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Machine ${_item.id}',
                  style: GoogleFonts.firaSans(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                  ),
                ),

                if (widget.canRemove && !widget.readOnly)
                  GestureDetector(
                    onTap: widget.onRemove,
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
                        'Remove Line',
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

            const SizedBox(height: 24),

            // MACHINE NAME
            _fieldLabelRequired('Machine name', deniedColor),
            const SizedBox(height: 8),

            _buildTextField(
              controller: _item.nameController,
              hint: 'e.g Water pump, Elevator',
              readOnly: widget.readOnly,
            ),

            const SizedBox(height: 20),

            // RATED POWER
            _fieldLabelRequired('Rated power (kW)', deniedColor),
            const SizedBox(height: 8),

            _buildTextField(
              controller: _item.ratedPowerController,
              hint: 'e.g 5.5',
              keyboardType: TextInputType.number,
              readOnly: widget.readOnly,
            ),

            const SizedBox(height: 20),

            // QUANTITY
            _fieldLabelRequired('Quantity', deniedColor),
            const SizedBox(height: 8),

            _buildTextField(
              controller: _item.quantityController,
              hint: 'e.g 3',
              keyboardType: TextInputType.number,
              readOnly: widget.readOnly,
            ),

            const SizedBox(height: 20),

            // OPERATING HOURS
            _fieldLabelRequired('Yearly operating hours', deniedColor),
            const SizedBox(height: 8),

            _buildTextField(
              controller: _item.yearlyHoursController,
              hint: 'e.g 4000',
              keyboardType: TextInputType.number,
              readOnly: widget.readOnly,
            ),

            const SizedBox(height: 24),

            // TOTALS
            Row(
              children: [
                Expanded(
                  child: _ReadOnlyField(
                    label: 'Total Power (kW)',
                    value: _item.totalPower > 0
                        ? _item.totalPower.toStringAsFixed(2)
                        : '',
                    asteriskColor: readyColor,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _ReadOnlyField(
                    label: 'Energy Cost (JD)',
                    value: _item.energyCost > 0
                        ? _item.energyCost.toStringAsFixed(2)
                        : '',
                    asteriskColor: readyColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a styled text field for the machine form.
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return SizedBox(
      height: 65,
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        expands: true,
        maxLines: null,
        keyboardType: keyboardType,
        style: GoogleFonts.firaSans(fontSize: 24, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.firaSans(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF808080),
          ),
          filled: readOnly,
          fillColor: const Color(0xFFEEEEEE),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Color(0xFF808080)),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Color(0xFF808080)),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────
Widget _fieldLabelRequired(String text, Color asteriskColor) => RichText(
  text: TextSpan(
    children: [
      TextSpan(
        text: text,
        style: GoogleFonts.firaSans(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      TextSpan(
        text: ' *',
        style: GoogleFonts.firaSans(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: asteriskColor,
        ),
      ),
    ],
  ),
);

/// A read-only display field showing a computed value in a green-tinted box.
class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value, this.asteriskColor = deniedColor});
  final String label;
  final String value;
  final Color asteriskColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabelRequired(label, asteriskColor),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13.5),
          decoration: BoxDecoration(
            color: const Color(0xFFe8f5e9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF808080), width: 2.0),
          ),
          child: Text(
            value.isEmpty ? '——' : value,
            style: GoogleFonts.firaSans(
              fontSize: 24,
              color: value.isEmpty ? const Color(0xFFAAAAAA) : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab button
// ─────────────────────────────────────────────────────────────────────────────
/// Animated tab button for switching between machine items.
class _MachineTabButton extends StatelessWidget {
  const _MachineTabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 78,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        constraints: const BoxConstraints(minWidth: 180),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isActive ? primaryColor : const Color(0xFF808080),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.firaSans(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Add (+) tab button
// ─────────────────────────────────────────────────────────────────────────────
/// The '+' button at the end of the tab row that adds a new machine item.
class _AddTabButton extends StatelessWidget {
  const _AddTabButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 78,
        height: 78,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: const Icon(Icons.add, size: 36, color: Colors.black),
      ),
    );
  }
}
