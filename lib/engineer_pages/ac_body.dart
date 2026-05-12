import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/firebase/project_service.dart';
import 'package:greenlens/main.dart';
import '../shared_files/fotter.dart';
import 'shared_files/ac_forum_state.dart';
import 'shared_files/group_forum.dart';

class AcBody extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final String projectId;
  const AcBody({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    required this.projectId,
  });

  @override
  State<AcBody> createState() => _AcBodyState();
}

class _AcBodyState extends State<AcBody> {
  int _activeGroup = 0;
  final List<int> _extraGroup = [];
  int _nextGroupId = 1;

  // One _GroupFormState per group — index 0 = Area 1, rest = extra groups
  final List<GroupFormState> _groupStates = [GroupFormState()];

  Future<void> _save() async {
    final groups = _groupStates.map((s) => s.toMap()).toList();
    await ProjectService().saveAuditSection(widget.projectId, 'ac', groups);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved successfully')),
      );
    }
  }

  String _extraGroupLabel(int id) => "Group ${_extraGroup.indexOf(id) + 2}";

  @override
  void dispose() {
    for (final s in _groupStates) {
      s.dispose();
    }
    super.dispose();
  }

  int get _activeGroupIndex {
    if (_activeGroup == 0) return 0;
    return _extraGroup.indexOf(_activeGroup) + 1;
  }

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

                  // "+" button
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
                            _groupStates.add(
                              GroupFormState(),
                            ); // 👈 new form state per group
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
                ),
              ),
            ),
            SizedBox(height: 16),

            // ── Footer ───────────────────────────────────────────────────────
            CreateNewProjectFooter(
              currentStep: widget.currentStep,
              onNext: widget.onNext,
              onBack: widget.onBack,
              mode: FooterMode.auditNormal,
              onSaveDraft: _save,
            ),
            SizedBox(height: 10000),
          ],
        ),
      ),
    );
  }
}

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
