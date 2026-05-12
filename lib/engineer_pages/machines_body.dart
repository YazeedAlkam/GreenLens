import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
import '../shared_files/fotter.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data model for one equipment item
// ─────────────────────────────────────────────────────────────────────────────
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

  // ← Priority: typed name → "Compressed Air" → "Equipment item N"
  String get tabLabel {
    final name = nameController.text.trim();
    if (name.isNotEmpty) return name;
    if (isCompressedAir) return 'Compressed Air';
    return 'Equipment item $id';
  }

  double get totalPower {
    final power = double.tryParse(ratedPowerController.text) ?? 0;
    final qty = double.tryParse(quantityController.text) ?? 0;
    return power * qty;
  }

  double get annualKwh {
    final hours = double.tryParse(yearlyHoursController.text) ?? 0;
    return totalPower * hours;
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'isCompressedAir': isCompressedAir,
    'name': nameController.text,
    'compressedAirType': compressedAirTypeController.text,
    'ratedPower': ratedPowerController.text,
    'quantity': quantityController.text,
    'yearlyHours': yearlyHoursController.text,
  };

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

  List<Map<String, dynamic>> getMachinesData() =>
      _items.map((i) => i.toMap()).toList();

  // ← Reassigns IDs 1,2,3... based on current list positions
  void _reassignIds() {
    for (int i = 0; i < _items.length; i++) {
      _items[i].id = i + 1;
    }
  }

  void _addItem() {
    setState(() {
      _items.add(MachineItem(id: _items.length + 1));
      _reassignIds();
      _activeIndex = _items.length - 1;
    });
  }

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
            CreateNewProjectFooter(
              currentStep: widget.currentStep,
              onNext: widget.onNext,
              onBack: widget.onBack,
              mode: FooterMode.auditNormal,
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

class _MachineFormState extends State<MachineForm> {
  MachineItem get _item => widget.item;

  void _recalculate() => setState(() {});

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
                        'Remove',
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
            _fieldLabelRequired('Machine name'),
            const SizedBox(height: 8),

            _buildTextField(
              controller: _item.nameController,
              hint: 'e.g Water pump, Elevator',
              readOnly: widget.readOnly,
            ),

            const SizedBox(height: 20),

            // RATED POWER
            _fieldLabelRequired('Rated power (kW)'),
            const SizedBox(height: 8),

            _buildTextField(
              controller: _item.ratedPowerController,
              hint: 'e.g 5.5',
              keyboardType: TextInputType.number,
              readOnly: widget.readOnly,
            ),

            const SizedBox(height: 20),

            // QUANTITY
            _fieldLabelRequired('Quantity'),
            const SizedBox(height: 8),

            _buildTextField(
              controller: _item.quantityController,
              hint: 'e.g 3',
              keyboardType: TextInputType.number,
              readOnly: widget.readOnly,
            ),

            const SizedBox(height: 20),

            // OPERATING HOURS
            _fieldLabelRequired('Yearly operating hours'),
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
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _ReadOnlyField(
                    label: 'Annual (kWh/yr)',
                    value: _item.annualKwh > 0
                        ? _item.annualKwh.toStringAsFixed(2)
                        : '',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
        style: GoogleFonts.firaSans(fontSize: 20, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.firaSans(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF808080),
          ),
          filled: readOnly,
          fillColor: const Color(0xFFEEEEEE),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Color(0xFF808080)),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Color(0xFF808080)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────
Widget _fieldLabelRequired(String text) => RichText(
  text: TextSpan(
    children: [
      TextSpan(
        text: text,
        style: GoogleFonts.firaSans(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      TextSpan(
        text: ' *',
        style: GoogleFonts.firaSans(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.deepOrange,
        ),
      ),
    ],
  ),
);

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabelRequired(label),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F0),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFCCCCCC), width: 1.5),
          ),
          child: Text(
            value.isEmpty ? '——' : value,
            style: GoogleFonts.firaSans(
              fontSize: 18,
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
