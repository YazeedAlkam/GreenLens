import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
import '../shared_files/footer.dart';



// ─────────────────────────────────────────────────────────────────────────────
// Data model for one equipment item
// ─────────────────────────────────────────────────────────────────────────────
class EquipmentItem {
  int id; // ← not final anymore so we can reassign after remove
  bool isCompressedAir;
  final TextEditingController nameController;
  final TextEditingController compressedAirTypeController;
  final TextEditingController ratedPowerController;
  final TextEditingController quantityController;
  final TextEditingController yearlyHoursController;

  EquipmentItem({required this.id})
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

  static EquipmentItem fromMap(Map<String, dynamic> map) {
    final item = EquipmentItem(id: (map['id'] as int?) ?? 1);
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
class ElectricalEquipmentBody extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final bool readOnly;
  final List<dynamic>? auditEquipmentData;
  final Future<void> Function()? onSaveDraft;

  const ElectricalEquipmentBody({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    this.readOnly = false,
    this.auditEquipmentData,
    this.onSaveDraft,
  });

  @override
  State<ElectricalEquipmentBody> createState() =>
      ElectricalEquipmentBodyState();
}

class ElectricalEquipmentBodyState extends State<ElectricalEquipmentBody> {
  final List<EquipmentItem> _items = [EquipmentItem(id: 1)];
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    final saved = widget.auditEquipmentData;
    if (saved == null || saved.isEmpty) return;
    _items.clear();
    for (final map in saved) {
      _items.add(EquipmentItem.fromMap(map as Map<String, dynamic>));
    }
    _reassignIds();
  }

  List<Map<String, dynamic>> getEquipmentData() =>
      _items.map((i) => i.toMap()).toList();

  // ← Reassigns IDs 1,2,3... based on current list positions
  void _reassignIds() {
    for (int i = 0; i < _items.length; i++) {
      _items[i].id = i + 1;
    }
  }

  void _addItem() {
    setState(() {
      _items.add(EquipmentItem(id: _items.length + 1));
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
              "Electrical Equipment",
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
                      child: _EquipmentTabButton(
                        label: item.tabLabel,
                        isActive: _activeIndex == idx,
                        onTap: () => setState(() => _activeIndex = idx),
                      ),
                    );
                  }),
                  if (!widget.readOnly)
                    _AddTabButton(onTap: _addItem),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Active form ─────────────────────────────────────────────────
            if (_items.isNotEmpty)
              EquipmentItemForm(
                key: ValueKey(_items[_activeIndex].id),
                item: _items[_activeIndex],
                readOnly: widget.readOnly,
                canRemove: _items.length > 1,
                onRemove: () => _removeItem(_activeIndex),
                onChanged: () => setState(() {}), // ← rebuilds tabs on name change
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
class EquipmentItemForm extends StatefulWidget {
  final EquipmentItem item;
  final bool readOnly;
  final bool canRemove;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  const EquipmentItemForm({
    super.key,
    required this.item,
    required this.readOnly,
    required this.canRemove,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  State<EquipmentItemForm> createState() => _EquipmentItemFormState();
}

class _EquipmentItemFormState extends State<EquipmentItemForm> {
  EquipmentItem get _item => widget.item;

  void _onCompressedAirToggled(bool? value) {
    setState(() {
      _item.isCompressedAir = value ?? false;
      if (_item.isCompressedAir) {
        _item.nameController.text = 'Compressed Air';
      } else {
        _item.nameController.clear();
        _item.compressedAirTypeController.clear();
      }
    });
    widget.onChanged();
  }

  void _recalculate() => setState(() {});

  // ← Triggers parent setState so tab label rerenders as user types
  void _onNameChanged() => widget.onChanged();

  @override
  void initState() {
    super.initState();
    _item.ratedPowerController.addListener(_recalculate);
    _item.quantityController.addListener(_recalculate);
    _item.yearlyHoursController.addListener(_recalculate);
    _item.nameController.addListener(_onNameChanged); // ← added
  }

  @override
  void dispose() {
    _item.ratedPowerController.removeListener(_recalculate);
    _item.quantityController.removeListener(_recalculate);
    _item.yearlyHoursController.removeListener(_recalculate);
    _item.nameController.removeListener(_onNameChanged); // ← added
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
            // ── Card header ───────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Item ${_item.id}',
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
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEDED),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Remove Item',
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

            // ── Compressed Air checkbox ───────────────────────────────────
            Row(
              children: [
                Checkbox(
                  value: _item.isCompressedAir,
                  onChanged: widget.readOnly ? null : _onCompressedAirToggled,
                  activeColor: primaryColor,
                ),
                Text(
                  'Compressed Air',
                  style: GoogleFonts.firaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Equipment name ────────────────────────────────────────────
            _fieldLabelRequired('Equipment name', deniedColor),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _item.nameController,
              hint: 'e.g Water pump, Elevator, Fans, ect.',
              readOnly: widget.readOnly || _item.isCompressedAir,
              filled: _item.isCompressedAir,
            ),
            const SizedBox(height: 16),

            // ── Compressed Air extra fields ───────────────────────────────
            if (_item.isCompressedAir) ...[
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabelRequired('Compressed Air Type', deniedColor),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _item.compressedAirTypeController,
                          hint: 'e.g 8',
                          readOnly: widget.readOnly,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabelRequired('Rated power (kW)', deniedColor),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _item.ratedPowerController,
                          hint: 'e.g 5.5',
                          keyboardType: TextInputType.number,
                          readOnly: widget.readOnly,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabelRequired('Quantity', deniedColor),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _item.quantityController,
                          hint: 'e.g 3',
                          keyboardType: TextInputType.number,
                          readOnly: widget.readOnly,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabelRequired('Yearly operating hours', deniedColor),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _item.yearlyHoursController,
                          hint: 'e.g 8',
                          keyboardType: TextInputType.number,
                          readOnly: widget.readOnly,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ] else ...[
              // ── Normal layout ─────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabelRequired('Rated power (kW)', deniedColor),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _item.ratedPowerController,
                          hint: 'e.g 5.5',
                          keyboardType: TextInputType.number,
                          readOnly: widget.readOnly,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabelRequired('Quantity', deniedColor),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _item.quantityController,
                          hint: 'e.g 3',
                          keyboardType: TextInputType.number,
                          readOnly: widget.readOnly,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _fieldLabelRequired('Yearly operating hours', deniedColor),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _item.yearlyHoursController,
                hint: 'e.g 8',
                keyboardType: TextInputType.number,
                readOnly: widget.readOnly,
              ),
            ],

            const SizedBox(height: 16),

            // ── Read-only totals ──────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _ReadOnlyField(
                    label: 'Energy Cost (JD)',
                    value: _item.totalPower > 0
                        ? _item.totalPower.toStringAsFixed(2)
                        : '',
                    astrickColor: readyColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ReadOnlyField(
                    label: 'Annual (kWh/yr)',
                    value: _item.annualKwh > 0
                        ? _item.annualKwh.toStringAsFixed(2)
                        : '',
                    astrickColor: readyColor,
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
    bool filled = false,
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
        style: GoogleFonts.firaSans(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.firaSans(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF808080),
          ),
          filled: readOnly || filled,
          fillColor: const Color(0xFFe0e0e0),
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
Widget _fieldLabelRequired(String text, Color astrickColor) => RichText(
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
              color: astrickColor,
            ),
          ),
        ],
      ),
    );

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value, this.astrickColor = deniedColor});
  final String label;
  final String value;
  final Color astrickColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabelRequired(label, astrickColor),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFe8f5e9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF808080), width: 2),
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
class _EquipmentTabButton extends StatelessWidget {
  const _EquipmentTabButton({
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