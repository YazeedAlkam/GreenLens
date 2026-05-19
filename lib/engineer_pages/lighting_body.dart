import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/engineer_pages/area_info_forums.dart';
import 'package:greenlens/main.dart';

import '../shared_files/footer.dart';

class LightingBody extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final List<dynamic>? auditLightingData;
  final Future<void> Function()? onSaveDraft;
  final bool readOnly;

  const LightingBody({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    this.auditLightingData,
    this.onSaveDraft,
    this.readOnly = false,
  });

  @override
  State<LightingBody> createState() => LightingBodyState();
}

class LightingBodyState extends State<LightingBody>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _activeArea = 0;
  final List<int> _extraAreas = [];
  int _nextAreaId = 1;

  // Controllers for Area 1
  final _area1LightingType = TextEditingController();
  final _area1RatedPower = TextEditingController();
  final _area1NumLights = TextEditingController();
  final _area1YearlyHours = TextEditingController();
  final _area1TotalPower = TextEditingController();
  final _area1Annual = TextEditingController();

  // Controllers for dynamically added extra areas
  // Each entry is [lightingType, ratedPower, numLights, yearlyHours, totalPower, annual]
  final List<List<TextEditingController>> _extraAreaCtrls = [];

  void _populateArea(List<TextEditingController> ctrls, Map<String, dynamic> area) {
    ctrls[0].text = area['lightingType']?.toString() ?? '';
    ctrls[1].text = area['ratedPower']?.toString() ?? '';
    ctrls[2].text = area['numLights']?.toString() ?? '';
    ctrls[3].text = area['yearlyHours']?.toString() ?? '';
    ctrls[4].text = area['totalPower']?.toString() ?? '';
    ctrls[5].text = area['annual']?.toString() ?? '';
  }

  @override
  void initState() {
    super.initState();
    final saved = widget.auditLightingData;
    if (saved == null || saved.isEmpty) return;

    final first = saved[0] as Map<String, dynamic>;
    _populateArea([
      _area1LightingType, _area1RatedPower, _area1NumLights,
      _area1YearlyHours, _area1TotalPower, _area1Annual,
    ], first);

    for (int i = 1; i < saved.length; i++) {
      final ctrls = List.generate(6, (_) => TextEditingController());
      _populateArea(ctrls, saved[i] as Map<String, dynamic>);
      _extraAreas.add(_nextAreaId);
      _extraAreaCtrls.add(ctrls);
      _nextAreaId++;
    }
  }

  @override
  void dispose() {
    _area1LightingType.dispose();
    _area1RatedPower.dispose();
    _area1NumLights.dispose();
    _area1YearlyHours.dispose();
    _area1TotalPower.dispose();
    _area1Annual.dispose();
    for (final ctrls in _extraAreaCtrls) {
      for (final c in ctrls) {
        c.dispose();
      }
    }
    super.dispose();
  }

  Map<String, String> _areaCtrlsToMap(List<TextEditingController> ctrls) => {
    'lightingType': ctrls[0].text,
    'ratedPower': ctrls[1].text,
    'numLights': ctrls[2].text,
    'yearlyHours': ctrls[3].text,
    'totalPower': ctrls[4].text,
    'annual': ctrls[5].text,
  };

  List<Map<String, String>> getLightingData() => [
    {
      'lightingType': _area1LightingType.text,
      'ratedPower': _area1RatedPower.text,
      'numLights': _area1NumLights.text,
      'yearlyHours': _area1YearlyHours.text,
      'totalPower': _area1TotalPower.text,
      'annual': _area1Annual.text,
    },
    ..._extraAreaCtrls.map(_areaCtrlsToMap),
  ];

  String _extraAreaLabel(int id) => "Area ${_extraAreas.indexOf(id) + 2}";

  void _deleteArea1() {
    if (_extraAreas.isEmpty) return;
    final promotedCtrls = _extraAreaCtrls[0];
    _area1LightingType.text = promotedCtrls[0].text;
    _area1RatedPower.text = promotedCtrls[1].text;
    _area1NumLights.text = promotedCtrls[2].text;
    _area1YearlyHours.text = promotedCtrls[3].text;
    _area1TotalPower.text = promotedCtrls[4].text;
    _area1Annual.text = promotedCtrls[5].text;
    for (final c in promotedCtrls) {
      c.dispose();
    }
    setState(() {
      _extraAreas.removeAt(0);
      _extraAreaCtrls.removeAt(0);
      _activeArea = 0;
    });
  }

  void _deleteCurrentExtraArea() {
    final idx = _extraAreas.indexOf(_activeArea);
    if (idx == -1) return;
    for (final c in _extraAreaCtrls[idx]) {
      c.dispose();
    }
    setState(() {
      _extraAreas.removeAt(idx);
      _extraAreaCtrls.removeAt(idx);
      if (_extraAreas.isEmpty) {
        _activeArea = 0;
      } else {
        _activeArea = _extraAreas[(idx - 1).clamp(0, _extraAreas.length - 1)];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                "Lighting Systems",
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

          // ── Area tabs ────────────────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _AreaTabButton(
                  label: "Area 1",
                  isActive: _activeArea == 0,
                  width: 260,
                  onTap: () => setState(() => _activeArea = 0),
                ),
                const SizedBox(width: 18),

                ..._extraAreas.map((id) {
                  return Row(
                    children: [
                      _AreaTabButton(
                        label: _extraAreaLabel(id),
                        isActive: _activeArea == id,
                        width: 260,
                        onTap: () => setState(() => _activeArea = id),
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
                            6,
                            (_) => TextEditingController(),
                          );
                          setState(() {
                            _extraAreas.add(_nextAreaId);
                            _extraAreaCtrls.add(ctrls);
                            _activeArea = _nextAreaId;
                            _nextAreaId++;
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

          const SizedBox(height: 16, width: double.infinity),

          // ── Area form ────────────────────────────────────────────────────
          IndexedStack(
            index: _activeArea == 0 ? 0 : _extraAreas.indexOf(_activeArea) + 1,
            children: [
              MainAreaForums(
                lightingTypeController: _area1LightingType,
                ratedPowerController: _area1RatedPower,
                numLightsController: _area1NumLights,
                yearlyHoursController: _area1YearlyHours,
                totalPowerController: _area1TotalPower,
                annualController: _area1Annual,
                canDelete: _extraAreas.isNotEmpty,
                onDelete: _deleteArea1,
                readOnly: widget.readOnly,
              ),
              ..._extraAreaCtrls.asMap().entries.map(
                (entry) => MainAreaForums(
                  lightingTypeController: entry.value[0],
                  ratedPowerController: entry.value[1],
                  numLightsController: entry.value[2],
                  yearlyHoursController: entry.value[3],
                  totalPowerController: entry.value[4],
                  annualController: entry.value[5],
                  canDelete: true,
                  onDelete: _deleteCurrentExtraArea,
                  readOnly: widget.readOnly,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // ── Footer ───────────────────────────────────────────────────────
          Footer(
            currentStep: widget.currentStep,
            onNext: widget.onNext,
            onBack: widget.onBack,
            mode: widget.readOnly ? FooterMode.viewOnly : FooterMode.auditNormal,
            onSaveDraft: widget.onSaveDraft,
          ),
        ],
      ),
    );
  }
}

class _AreaTabButton extends StatelessWidget {
  const _AreaTabButton({
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
