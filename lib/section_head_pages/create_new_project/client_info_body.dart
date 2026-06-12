// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greenlens/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/section_head_pages/create_new_project/contact_info_forums.dart';
import 'package:greenlens/shared_files/footer.dart';

/// Step 1 of the Create Project wizard: client contact information.
///
/// Supports one primary contact (Contact 1) and optional extra contacts.
/// When [readOnly] is true all fields are disabled.
class ClientInfoBody extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final Future<void> Function() onSaveDraft;
  final String projectId;
  final Map<String, dynamic>? initialClientInfo;
  final bool readOnly;

  const ClientInfoBody({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    required this.onSaveDraft,
    this.projectId = '',
    this.initialClientInfo,
    this.readOnly = false,
  });

  @override
  ClientInfoBodyState createState() => ClientInfoBodyState();
}

/// State for [ClientInfoBody]. Uses [AutomaticKeepAliveClientMixin] to preserve
/// form data when the user navigates between wizard steps.
class ClientInfoBodyState extends State<ClientInfoBody>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Which contact tab is showing: 0 = main contact, 1 = second contact,
  // 2+ = ids of dynamically added extra contacts.
  int _activeContact = 0;

  // Ids of the extra contact tabs, in display order. Ids are never reused
  // (see [_nextContactId]) so deleting a tab can't confuse the active tab.
  final List<int> _extraContacts = [];
  int _nextContactId = 2;

  @override
  void initState() {
    super.initState();
    // Pre-fill when editing an existing draft/project; null = new project.
    final data = widget.initialClientInfo;
    if (data == null) return;

    final main = data['mainContact'] as Map<String, dynamic>? ?? {};
    _mainNameCtrl.text = main['name'] ?? '';
    _mainPositionCtrl.text = main['position'] ?? '';
    _mainEmailCtrl.text = main['email'] ?? '';
    _mainPhoneCtrl.text = main['phone'] ?? '';

    final second = data['secondContact'] as Map<String, dynamic>? ?? {};
    _secondNameCtrl.text = second['name'] ?? '';
    _secondPositionCtrl.text = second['position'] ?? '';
    _secondEmailCtrl.text = second['email'] ?? '';
    _secondPhoneCtrl.text = second['phone'] ?? '';

    final extras = data['extraContacts'] as List? ?? [];
    for (final contact in extras) {
      final c = contact as Map<String, dynamic>;
      final ctrls = [
        TextEditingController(text: c['name'] ?? ''),
        TextEditingController(text: c['position'] ?? ''),
        TextEditingController(text: c['email'] ?? ''),
        TextEditingController(text: c['phone'] ?? ''),
      ];
      _extraContacts.add(_nextContactId);
      _extraContactCtrls.add(ctrls);
      _nextContactId++;
    }
  }

  // Controllers for main client contact
  final _mainNameCtrl = TextEditingController();
  final _mainPositionCtrl = TextEditingController();
  final _mainEmailCtrl = TextEditingController();
  final _mainPhoneCtrl = TextEditingController();

  // Controllers for second contact
  final _secondNameCtrl = TextEditingController();
  final _secondPositionCtrl = TextEditingController();
  final _secondEmailCtrl = TextEditingController();
  final _secondPhoneCtrl = TextEditingController();

  // Each entry is [nameCtrl, positionCtrl, emailCtrl, phoneCtrl] for an extra contact
  final List<List<TextEditingController>> _extraContactCtrls = [];

  @override
  void dispose() {
    _mainNameCtrl.dispose();
    _mainPositionCtrl.dispose();
    _mainEmailCtrl.dispose();
    _mainPhoneCtrl.dispose();
    _secondNameCtrl.dispose();
    _secondPositionCtrl.dispose();
    _secondEmailCtrl.dispose();
    _secondPhoneCtrl.dispose();
    for (final ctrls in _extraContactCtrls) {
      for (final c in ctrls) {
        c.dispose();
      }
    }
    super.dispose();
  }

  /// Collects all contacts into the `clientInfo` map saved to Firestore.
  Map<String, dynamic> getClientInfo() {
    return {
      'mainContact': {
        'name': _mainNameCtrl.text,
        'position': _mainPositionCtrl.text,
        'email': _mainEmailCtrl.text,
        'phone': _mainPhoneCtrl.text,
      },
      'secondContact': {
        'name': _secondNameCtrl.text,
        'position': _secondPositionCtrl.text,
        'email': _secondEmailCtrl.text,
        'phone': _secondPhoneCtrl.text,
      },
      'extraContacts': _extraContactCtrls
          .map(
            (ctrls) => {
              'name': ctrls[0].text,
              'position': ctrls[1].text,
              'email': ctrls[2].text,
              'phone': ctrls[3].text,
            },
          )
          .toList(),
    };
  }

  /// Tab label for an extra contact: position-based, starting at "Contact 3"
  /// (Contact 1 and 2 are the fixed main/second contacts).
  String _extraContactLabel(int id) =>
      "Contact ${_extraContacts.indexOf(id) + 3}";

  /// Removes the currently selected extra contact tab, disposes its
  /// controllers, and selects the nearest remaining tab (or Second Contact
  /// when no extra tabs are left).
  void _deleteCurrentExtraContact() {
    final idx = _extraContacts.indexOf(_activeContact);
    if (idx == -1) return;
    for (final c in _extraContactCtrls[idx]) {
      c.dispose();
    }
    setState(() {
      _extraContacts.removeAt(idx);
      _extraContactCtrls.removeAt(idx);
      if (_extraContacts.isEmpty) {
        _activeContact = 1;
      } else {
        _activeContact =
            _extraContacts[(idx - 1).clamp(0, _extraContacts.length - 1)];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          // ── Header row ──────────────────────────────────────────────────
          Row(
            children: [
              ElevatedButton(
                onPressed: widget.onBack,
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
              const SizedBox(width: 10),
              Text(
                "Client Info",
                style: GoogleFonts.firaSans(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),

          Divider(color: const Color(0xFFa8a6a7), height: 2, thickness: 2),
          const SizedBox(height: 16, width: double.infinity),

          // ── Client ID ───────────────────────────────────────────────────
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Client ID",
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16, width: double.infinity),
          SizedBox(
            height: 65,
            child: TextField(
              readOnly: true,
              expands: true,
              maxLines: null,
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: widget.projectId.isEmpty ? '...' : widget.projectId,
                hintStyle: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                filled: true,
                fillColor: disableColor,
                hoverColor: disableColor,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16, width: double.infinity),

          // ── Contact tabs ─────────────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _ContactTabButton(
                  label: "Client Contact",
                  isActive: _activeContact == 0,
                  width: 423,
                  onTap: () => setState(() => _activeContact = 0),
                ),
                const SizedBox(width: 18),
                _ContactTabButton(
                  label: "Second Contact",
                  isActive: _activeContact == 1,
                  width: 423,
                  onTap: () => setState(() => _activeContact = 1),
                ),
                const SizedBox(width: 18),

                ..._extraContacts.map((id) {
                  return Row(
                    children: [
                      _ContactTabButton(
                        label: _extraContactLabel(id),
                        isActive: _activeContact == id,
                        width: 260,
                        onTap: () => setState(() => _activeContact = id),
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
                          final ctrls = List.generate(
                            4,
                            (_) => TextEditingController(),
                          );
                          setState(() {
                            _extraContacts.add(_nextContactId);
                            _extraContactCtrls.add(ctrls);
                            _activeContact = _nextContactId;
                            _nextContactId++;
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
                          'assets/images/add.svg',
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

          const SizedBox(height: 16, width: double.infinity),

          // ── Contact form ─────────────────────────────────────────────────
          IndexedStack(
            index: _activeContact == 0
                ? 0
                : _activeContact == 1
                ? 1
                : _extraContacts.indexOf(_activeContact) + 2,
            children: [
              MainClientForum(
                nameController: _mainNameCtrl,
                positionController: _mainPositionCtrl,
                emailController: _mainEmailCtrl,
                phoneController: _mainPhoneCtrl,
                readOnly: widget.readOnly,
              ),
              OtherContactsForum(
                nameController: _secondNameCtrl,
                positionController: _secondPositionCtrl,
                emailController: _secondEmailCtrl,
                phoneController: _secondPhoneCtrl,
                readOnly: widget.readOnly,
              ),
              ..._extraContactCtrls.map(
                (ctrls) => OtherContactsForum(
                  nameController: ctrls[0],
                  positionController: ctrls[1],
                  emailController: ctrls[2],
                  phoneController: ctrls[3],
                  readOnly: widget.readOnly,
                ),
              ),
            ],
          ),

          if (!widget.readOnly && _extraContacts.contains(_activeContact)) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 65,
              child: ElevatedButton(
                onPressed: _deleteCurrentExtraContact,
                style: ElevatedButton.styleFrom(
                  backgroundColor: deniedColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Delete Contact",
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 32),

          // ── Footer ───────────────────────────────────────────────────────
          Footer(
            currentStep: widget.currentStep,
            onNext: widget.onNext,
            onBack: widget.onBack,
            onSaveDraft: widget.onSaveDraft,
            mode: widget.readOnly ? FooterMode.viewOnly : FooterMode.normal,
          ),
        ],
      ),
    );
  }
}

/// A tab button for switching between client contacts.
class _ContactTabButton extends StatelessWidget {
  const _ContactTabButton({
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
