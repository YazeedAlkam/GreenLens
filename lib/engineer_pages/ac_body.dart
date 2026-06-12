import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
import '../shared_files/footer.dart';
import 'shared_files/ac_forum_state.dart';
import 'shared_files/group_forum.dart';

/// Step 3 of the audit entry wizard: AC / HVAC group data entry.
///
/// Supports multiple cooling groups (tab-based). Group 1 always exists; extra
/// groups can be added or deleted. When [readOnly] is true all fields are disabled.
class AcBody extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final List<dynamic>? auditAcData;
  final Future<void> Function()? onSaveDraft;
  final bool readOnly;
  const AcBody({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    this.auditAcData,
    this.onSaveDraft,
    this.readOnly = false,
  });

  @override
  State<AcBody> createState() => AcBodyState();
}

/// State for [AcBody]. Manages a list of [GroupFormState] objects (one per group)
/// and exposes [getAcData] so the parent wizard can collect data via a [GlobalKey].
class AcBodyState extends State<AcBody> {
  int _activeGroup = 0;
  final List<int> _extraGroup = [];
  int _nextGroupId = 1;

  // One _GroupFormState per group — index 0 = Area 1, rest = extra groups
  final List<GroupFormState> _groupStates = [GroupFormState()];

  @override
  void initState() {
    super.initState();
    final saved = widget.auditAcData;
    if (saved == null || saved.isEmpty) return;

    _groupStates[0].fromMap(saved[0] as Map<String, dynamic>);

    for (int i = 1; i < saved.length; i++) {
      final state = GroupFormState()..fromMap(saved[i] as Map<String, dynamic>);
      _groupStates.add(state);
      _extraGroup.add(_nextGroupId);
      _nextGroupId++;
    }
  }

  /// Returns all AC groups as a list of maps to be stored under
  /// `auditData.ac` in Firestore.
  List<Map<String, dynamic>> getAcData() =>
      _groupStates.map((s) => s.toMap()).toList();

  /// Returns the tab label for an extra group, e.g. "Group 2", "Group 3".
  String _extraGroupLabel(int id) => "Group ${_extraGroup.indexOf(id) + 2}";

  /// Removes the currently active group tab, promoting the next group if Group 1
  /// is deleted, or selecting the nearest remaining group otherwise.
  void _deleteActiveGroup() {
    if (_groupStates.length <= 1) return;
    if (_activeGroup == 0) {
      // Promote the first extra group into Group 1
      _groupStates[0].fromMap(_groupStates[1].toMap());
      _groupStates[1].dispose();
      setState(() {
        _groupStates.removeAt(1);
        _extraGroup.removeAt(0);
        _activeGroup = 0;
      });
    } else {
      final idx = _activeGroupIndex;
      final extraIdx = _extraGroup.indexOf(_activeGroup);
      _groupStates[idx].dispose();
      setState(() {
        _groupStates.removeAt(idx);
        _extraGroup.removeAt(extraIdx);
        if (_extraGroup.isEmpty) {
          _activeGroup = 0;
        } else {
          _activeGroup = _extraGroup[(extraIdx - 1).clamp(0, _extraGroup.length - 1)];
        }
      });
    }
  }

  @override
  void dispose() {
    for (final s in _groupStates) {
      s.dispose();
    }
    super.dispose();
  }

  /// Returns the zero-based index into [_groupStates] for the active tab.
  int get _activeGroupIndex {
    if (_activeGroup == 0) return 0;
    return _extraGroup.indexOf(_activeGroup) + 1;
  }

  /// Returns the display label for the currently active group tab.
  String get _activeGroupLabel {
    if (_activeGroup == 0) return 'Group 1';
    return _extraGroupLabel(_activeGroup);
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
              "AC Systems",
              style: GoogleFonts.firaSans(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: dividerColor),
            const SizedBox(height: 16),
            // ── Group Tabs ──────────────────────────────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _GroupTabButton(
                    label: "Group 1",
                    isActive: _activeGroup == 0,
                    width: 260,
                    onTap: () => setState(() => _activeGroup = 0),
                  ),
                  const SizedBox(width: 18),

                  ..._extraGroup.map((id) {
                    return Row(
                      children: [
                        _GroupTabButton(
                          label: _extraGroupLabel(id),
                          isActive: _activeGroup == id,
                          width: 260,
                          onTap: () => setState(() => _activeGroup = id),
                        ),
                        const SizedBox(width: 18),
                      ],
                    );
                  }),

                  if (!widget.readOnly)
                    Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: SizedBox.expand(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _extraGroup.add(_nextGroupId);
                              _groupStates.add(GroupFormState());
                              _activeGroup = _nextGroupId;
                              _nextGroupId++;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: const BorderSide(
                                width: 0,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          child: SvgPicture.asset(
                            'assets/images/Add.svg',
                            width: 51,
                            height: 51,
                            colorFilter: ColorFilter.mode(
                              addclientbuttoncolor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Groups Forums ───────────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, anim) =>
                  FadeTransition(opacity: anim, child: child),
              child: KeyedSubtree(
                key: ValueKey(_activeGroup),
                child: GroupForm(
                  label: _activeGroupLabel,
                  state: _groupStates[_activeGroupIndex],
                  onChanged: () => setState(() {}),
                  canDelete: _groupStates.length > 1,
                  onDelete: _deleteActiveGroup,
                  readOnly: widget.readOnly,
                ),
              ),
            ),
            SizedBox(height: 16),

            // ── Footer ───────────────────────────────────────────────────────
            Footer(
              currentStep: widget.currentStep,
              onNext: widget.onNext,
              onBack: widget.onBack,
              mode: widget.readOnly ? FooterMode.viewOnly : FooterMode.auditNormal,
              onSaveDraft: widget.onSaveDraft,
            ),
            SizedBox(height: 10000),
          ],
        ),
      ),
    );
  }
}

/// A tab button for switching between AC groups.
///
/// Renders with the primary background when [isActive] is true.
class _GroupTabButton extends StatelessWidget {
  const _GroupTabButton({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.width = 423,
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
          color: isActive ? const Color(0xFF0d123f) : const Color(0xFF808080),
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
              side: const BorderSide(width: 0, color: Colors.transparent),
            ),
          ),
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
