import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
import 'ac_forum_state.dart';

class GroupForm extends StatelessWidget {
  const GroupForm({
    super.key,
    required this.label,
    required this.state,
    required this.onChanged,
    this.canDelete = false,
    this.onDelete,
    this.readOnly = false,
  });

  final String label;
  final GroupFormState state;
  final VoidCallback onChanged;
  final bool canDelete;
  final VoidCallback? onDelete;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AC unit – $label',
                style: GoogleFonts.firaSans(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
              if (!readOnly && canDelete && onDelete != null)
                GestureDetector(
                  onTap: onDelete,
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
                      'Delete Group',
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

          // HVAC type label
          _fieldLabel('AC type'),
          const SizedBox(height: 8),

          // ── AC type selector (Split / Packaged / Central) ──
          IgnorePointer(
            ignoring: readOnly,
            child: Row(
              children: [
                _AcTypeButton(
                  label: 'Split',
                  isActive: state.activeType == 0,
                  onTap: () {
                    state.activeType = 0;
                    onChanged();
                  },
                ),
                const SizedBox(width: 8),
                _AcTypeButton(
                  label: 'Packaged',
                  isActive: state.activeType == 1,
                  onTap: () {
                    state.activeType = 1;
                    onChanged();
                  },
                ),
                const SizedBox(width: 8),
                _AcTypeButton(
                  label: 'Central',
                  isActive: state.activeType == 2,
                  onTap: () {
                    state.activeType = 2;
                    onChanged();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Dynamic form body — switches on AC type ──
          IgnorePointer(
            ignoring: readOnly,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, anim) =>
                  FadeTransition(opacity: anim, child: child),
              child: KeyedSubtree(
                key: ValueKey(state.activeType),
                child: _buildTypeForm(state, onChanged, readOnly: readOnly),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Picks the right form for the selected AC type ──
  static Widget _buildTypeForm(GroupFormState s, VoidCallback onChange, {bool readOnly = false}) {
    switch (s.activeType) {
      case 0:
        return _SplitForm(state: s, onChanged: onChange, readOnly: readOnly);
      case 1:
        return _PackagedForm(state: s, onChanged: onChange, readOnly: readOnly);
      case 2:
        return _CentralForm(state: s, onChanged: onChange, readOnly: readOnly);
      default:
        return const SizedBox.shrink();
    }
  }

  static Widget _fieldLabel(String textt) => RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: textt,
          style: GoogleFonts.firaSans(
            fontSize: 24,
            fontWeight: FontWeight.w500, //meduim
            color: Colors.black87,
          ),
        ),
        TextSpan(
          text: " *",
          style: GoogleFonts.firaSans(
            fontSize: 24,
            fontWeight: FontWeight.w500, //meduim
            color: Colors.deepOrange,
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────
//  Split form
// ─────────────────────────────────────────────────────────────
class _SplitForm extends StatelessWidget {
  const _SplitForm({required this.state, required this.onChanged, this.readOnly = false});
  final GroupFormState state;
  final VoidCallback onChanged;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Inverter toggle
        _fieldLabelRequired('Type', deniedColor),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _ToggleButton(
                label: 'Inverter',
                isActive: state.activeInvertor == 0,
                onTap: () {
                  state.activeInvertor = 0;
                  onChanged();
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ToggleButton(
                label: 'Non-Invertor',
                isActive: state.activeInvertor == 1,
                onTap: () {
                  state.activeInvertor = 1;
                  onChanged();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // No. of units + Capacity
        Row(
          children: [
            Expanded(
              child: _FormField(
                label: 'No. of units',
                hint: 'e.g 120',
                controller: state.noOfUnits,
                onChanged: (_) => onChanged(),
                maxLines: null,
                readOnly: readOnly,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _FormField(
                label: 'Capacity (tones)',
                hint: 'e.g 36',
                controller: state.capacity,
                onChanged: (_) => onChanged(),
                maxLines: null,
                readOnly: readOnly,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Yearly hours + Rated power
        Row(
          children: [
            Expanded(
              child: _FormField(
                label: 'Yearly operating hours',
                hint: 'e.g 36',
                controller: state.yearlyHours,
                onChanged: (_) => onChanged(),
                maxLines: null,
                readOnly: readOnly,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _FormField(
                label: 'Rated Power (kW)',
                hint: 'e.g 36',
                controller: state.ratedPower,
                onChanged: (_) => onChanged(),
                maxLines: null,
                readOnly: readOnly,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Total power + Annual (read-only)
        Row(
          children: [
            Expanded(
              child: _ReadOnlyField(
                label: 'Total power (kW)',
                value: state.totalPower,
                astrickColor: readyColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ReadOnlyField(
                label: 'Annual (kWh/yr)',
                value: state.annualKwh,
                astrickColor: readyColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Notes
        _FormFieldUnRequired(
          label: 'Notes / Observations',
          hint: 'Any observations during site visit...',
          controller: state.notes,
          onChanged: (_) => onChanged(),
          maxLines: 3,
          readOnly: readOnly,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Packaged form — NO toggle, just fields directly
// ─────────────────────────────────────────────────────────────
class _PackagedForm extends StatelessWidget {
  const _PackagedForm({required this.state, required this.onChanged, this.readOnly = false});
  final GroupFormState state;
  final VoidCallback onChanged;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // No. of units + Capacity
        Row(
          children: [
            Expanded(
              child: _FormField(
                label: 'No. of units',
                hint: 'e.g 120',
                controller: state.noOfPackages,
                onChanged: (_) => onChanged(),
                maxLines: null,
                readOnly: readOnly,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _FormField(
                label: 'Capacity (tones)',
                hint: 'e.g 36',
                controller: state.packageCapacity,
                onChanged: (_) => onChanged(),
                maxLines: null,
                readOnly: readOnly,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Yearly hours + Rated power
        Row(
          children: [
            Expanded(
              child: _FormField(
                label: 'Yearly operating hours',
                hint: 'e.g 36',
                controller: state.packageHours,
                onChanged: (_) => onChanged(),
                maxLines: null,
                readOnly: readOnly,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _FormField(
                label: 'Rated Power (kW)',
                hint: 'e.g 36',
                controller: state.packagePower,
                onChanged: (_) => onChanged(),
                maxLines: null,
                readOnly: readOnly,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Total power + Annual (read-only)
        Row(
          children: [
            Expanded(
              child: _ReadOnlyField(
                label: 'Total power (kW)',
                value: state.packageTotalPower,
                astrickColor: readyColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ReadOnlyField(
                label: 'Annual (kWh/yr)',
                value: state.packageAnnualKwh,
                astrickColor: readyColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        _FormFieldUnRequired(
          label: 'Notes / Observations',
          hint: 'Any observations during site visit...',
          controller: state.packageNotes,
          onChanged: (_) => onChanged(),
          maxLines: 3,
          readOnly: readOnly,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Central form — "Chiller type" toggle: Air Cooler / Water Cooler
// ─────────────────────────────────────────────────────────────
class _CentralForm extends StatelessWidget {
  const _CentralForm({required this.state, required this.onChanged, this.readOnly = false});
  final GroupFormState state;
  final VoidCallback onChanged;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chiller type toggle
        _fieldLabelRequired('Chiller type', deniedColor),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _ToggleButton(
                label: 'Air Cooler',
                isActive: state.activeInvertor == 0,
                onTap: () {
                  state.activeInvertor = 0;
                  onChanged();
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ToggleButton(
                label: 'Water Cooler',
                isActive: state.activeInvertor == 1,
                onTap: () {
                  state.activeInvertor = 1;
                  onChanged();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // No. of units + Capacity
        Row(
          children: [
            Expanded(
              child: _FormField(
                label: 'No. of units',
                hint: 'e.g 120',
                controller: state.chillerCapacity,
                onChanged: (_) => onChanged(),
                maxLines: null,
                readOnly: readOnly,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _FormField(
                label: 'Capacity (tones)',
                hint: 'e.g 36',
                controller: state.ahuCount,
                onChanged: (_) => onChanged(),
                maxLines: null,
                readOnly: readOnly,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Yearly hours + Rated power
        Row(
          children: [
            Expanded(
              child: _FormField(
                label: 'Yearly operating hours',
                hint: 'e.g 36',
                controller: state.chillerHours,
                onChanged: (_) => onChanged(),
                maxLines: null,
                readOnly: readOnly,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _FormField(
                label: 'Rated Power (kW)',
                hint: 'e.g 10',
                controller: state.chillerPower,
                onChanged: (_) => onChanged(),
                maxLines: null,
                readOnly: readOnly,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Total power + Annual (read-only)
        Row(
          children: [
            Expanded(
              child: _ReadOnlyField(
                label: 'Total power (kW)',
                value: state.centralTotalPower,
                astrickColor: readyColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ReadOnlyField(
                label: 'Annual (kWh/yr)',
                value: state.centralAnnualKwh,
                astrickColor: readyColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        _FormFieldUnRequired(
          label: 'Notes / Observations',
          hint: 'Any observations during site visit...',
          controller: state.centralNotes,
          onChanged: (_) => onChanged(),
          maxLines: 3,
          readOnly: readOnly,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Reusable small widgets
// ─────────────────────────────────────────────────────────────
Widget _fieldLabelRequired(String text, Color astrickColor) => RichText(
  text: TextSpan(
    children: [
      TextSpan(
        text: text,
        style: GoogleFonts.firaSans(
          fontSize: 24,
          fontWeight: FontWeight.w500, //meduim
          color: Colors.black87,
        ),
      ),
      TextSpan(
        text: " *",
        style: GoogleFonts.firaSans(
          fontSize: 24,
          fontWeight: FontWeight.w500, //meduim
          color: astrickColor,
        ),
      ),
    ],
  ),
);
Widget _fieldLabelUnRequired(String textt) => RichText(
  text: TextSpan(
    children: [
      TextSpan(
        text: textt,
        style: GoogleFonts.firaSans(
          fontSize: 24,
          fontWeight: FontWeight.w500, //meduim
          color: Colors.black87,
        ),
      ),
    ],
  ),
);

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
    this.maxLines = 1,
    this.readOnly = false,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final int? maxLines;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabelRequired(label, deniedColor),
        const SizedBox(height: 6),
        SizedBox(
          height: 65,
          child: TextFormField(
            controller: controller,
            readOnly: readOnly,
            onChanged: onChanged,
            expands: true,
            maxLines: maxLines,
            keyboardType: maxLines == 1
                ? TextInputType.number
                : TextInputType.multiline,
            style: GoogleFonts.firaSans(fontSize: 24, color: Colors.black87),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.firaSans(
                fontSize: 24,
                color: const Color(0xFFAAAAAA),
              ),
              filled: true,
              fillColor: readOnly ? disableColor : Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF808080),
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF808080),
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Color(0xFF808080), width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
class _FormFieldUnRequired extends StatelessWidget {
  const _FormFieldUnRequired({
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
    this.maxLines = 1,
    this.readOnly = false,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final int maxLines;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabelUnRequired(label),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onChanged: onChanged,
          maxLines: maxLines,
          keyboardType: maxLines == 1
              ? TextInputType.number
              : TextInputType.multiline,
          style: GoogleFonts.firaSans(fontSize: 24, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.firaSans(
              fontSize: 24,
              color: const Color(0xFFAAAAAA),
            ),
            filled: true,
            fillColor: readOnly ? disableColor : Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFF808080),
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFF808080),
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Color(0xFF808080), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: const Color(
              0xFFe8f5e9,
            ), // light greenish tint like screenshot
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF808080), width: 2),
          ),
          child: Text(
            value.isEmpty ? '—' : value,
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

class _AcTypeButton extends StatelessWidget {
  const _AcTypeButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: isActive ? primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isActive ? primaryColor : const Color(0xFF808080),
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.firaSans(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
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
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isActive ? primaryColor : const Color(0xFF808080),
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.firaSans(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : primaryColor,
          ),
        ),
      ),
    );
  }
}

class _GroupTabButton extends StatelessWidget {
  const _GroupTabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.width = 200,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 78,
      decoration: BoxDecoration(
        color: isActive ? primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isActive ? primaryColor : const Color(0xFF808080),
          width: 2,
        ),
      ),
      child: SizedBox.expand(
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
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
