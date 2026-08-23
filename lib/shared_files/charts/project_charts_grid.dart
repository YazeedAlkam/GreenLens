import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:greenlens/firebase/project_service.dart';
import 'package:greenlens/main.dart';
import 'annual_consumption_card.dart';
import 'chart_theme.dart';
import 'estimated_cost_card.dart';
import 'potential_savings_card.dart';
import 'savings_donut_card.dart';

/// Assumed energy savings ratio applied to all "after implementation" chart series (20%).
const double _savingsFactor = 0.20;

/// Responsive 2×2 grid of the four project energy charts.
///
/// Loads project data from Firestore using [projectId], computes monthly kWh,
/// cost, and donut breakdown values, then renders:
///   1. Savings Donut        — energy cost split by system type
///   2. Annual Consumption   — monthly kWh line chart
///   3. Potential Savings    — before vs. after kWh bar chart
///   4. Estimated Cost       — current vs. savings-adjusted cost bar chart
///
/// Exposes [onCaptureReady] and [onCaptureCostChart] so parent pages can
/// capture chart PNGs for report generation without coupling to this widget.
class ProjectChartsGrid extends StatefulWidget {
  final String? projectId;
  final ChartTheme? theme;
  final double spacing;
  final void Function(Future<List<Uint8List?>> Function()?)? onCaptureReady;
  // Delivers a function that captures only chart 4 (Estimated Annual Cost).
  final void Function(Future<Uint8List?> Function()?)? onCaptureCostChart;

  const ProjectChartsGrid({
    super.key,
    this.projectId,
    this.theme,
    this.spacing = 12,
    this.onCaptureReady,
    this.onCaptureCostChart,
  });

  @override
  State<ProjectChartsGrid> createState() => ProjectChartsGridState();
}

/// State for [ProjectChartsGrid]. Exposed (public) so parent pages can hold a
/// [GlobalKey<ProjectChartsGridState>] to call [reload] after saving audit data.
class ProjectChartsGridState extends State<ProjectChartsGrid> {
  final List<GlobalKey> _chartKeys = List.generate(4, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    widget.onCaptureReady?.call(_captureCharts);
    widget.onCaptureCostChart?.call(_captureCostChart);
    _load();
  }

  /// Call this after saving audit data to refresh the charts.
  Future<void> reload() => _load();

  @override
  void didUpdateWidget(covariant ProjectChartsGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onCaptureReady != oldWidget.onCaptureReady) {
      oldWidget.onCaptureReady?.call(null);
      widget.onCaptureReady?.call(_captureCharts);
    }
    if (widget.onCaptureCostChart != oldWidget.onCaptureCostChart) {
      oldWidget.onCaptureCostChart?.call(null);
      widget.onCaptureCostChart?.call(_captureCostChart);
    }
  }

  @override
  void dispose() {
    widget.onCaptureReady?.call(null);
    widget.onCaptureCostChart?.call(null);
    super.dispose();
  }

  /// Captures one chart widget as a PNG via its [RepaintBoundary] key.
  /// Returns null if the widget is not currently in the render tree.
  Future<Uint8List?> _captureOne(int index) async {
    final key = _chartKeys[index];
    try {
      final ctx = key.currentContext;
      if (ctx == null) {
        debugPrint(
          '[Charts] chart${index + 1}: context is null (widget not in tree)',
        );
        return null;
      }
      final ro = ctx.findRenderObject();
      if (ro is! RenderRepaintBoundary) {
        debugPrint(
          '[Charts] chart${index + 1}: render object is $ro, not a RenderRepaintBoundary',
        );
        return null;
      }
      final image = await ro.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData?.buffer.asUint8List();
      debugPrint(
        '[Charts] chart${index + 1}: captured ${bytes?.length ?? 0} bytes',
      );
      return bytes;
    } catch (e) {
      debugPrint('[Charts] chart${index + 1}: ERROR $e');
      return null;
    }
  }

  /// Captures all four chart widgets sequentially and returns their PNG bytes.
  Future<List<Uint8List?>> _captureCharts() async {
    final results = <Uint8List?>[];
    for (int i = 0; i < _chartKeys.length; i++) {
      results.add(await _captureOne(i));
    }
    return results;
  }

  /// Captures only chart 4 (Estimated Annual Cost) for the standalone cost report.
  Future<Uint8List?> _captureCostChart() => _captureOne(3);

  bool _loading = true;

  // Chart 1 — Savings Donut
  List<SavingsCategory> _donutCategories = [];
  double _totalSavingPercent = 20;
  double _potentialAnnualSavingJod = 0;

  // Charts 2, 3, 4 — monthly data (12 values, chronological order)
  List<double> _monthlyKwh = List.filled(12, 0);
  List<double> _currentCostJod = List.filled(12, 0);
  List<String>? _monthLabels;
  double _tariffJodPerKwh = energyTariffJodPerKwh;

  /// Loads the project document from Firestore and recomputes all chart data
  /// (monthly bills, audit kWh totals, savings, and cost projections).
  Future<void> _load() async {
    if (widget.projectId == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    final project = await ProjectService().getProjectById(widget.projectId!);
    if (!mounted) return;

    if (project == null) {
      setState(() => _loading = false);
      return;
    }

    final projectInfo = project['projectInfo'] as Map<String, dynamic>? ?? {};
    final auditData = project['auditData'] as Map<String, dynamic>? ?? {};

    // ── Monthly bills ─────────────────────────────────────────────────────────
    final monthlyJod = _buildMonthlyBills(projectInfo);
    final calcTariff = _calcTariffFromBills(projectInfo);
    final tariff = calcTariff > 0 ? calcTariff : energyTariffJodPerKwh;
    final monthlyKwh = monthlyJod.values.map((v) => v / tariff).toList();

    // ── Energy cost per system (for donut) ────────────────────────────────────
    final lighting = auditData['lighting'] as List? ?? [];
    final ac = auditData['ac'] as List? ?? [];
    final equipment = auditData['equipment'] as List? ?? [];
    final machines = auditData['machines'] as List? ?? [];

    final lightingCost = _sumEnergyCost(lighting);
    final acCost = _acEnergyCost(ac, tariff);
    final equipmentCost = _sumEnergyCost(equipment);
    final machinesCost = _sumEnergyCost(machines);
    final totalCost = lightingCost + acCost + equipmentCost + machinesCost;

    List<SavingsCategory> categories = [];
    if (totalCost > 0) {
      final t = ChartTheme();
      categories = [
        if (lightingCost > 0)
          SavingsCategory(
            'Lighting',
            lightingCost / totalCost * 100,
            t.primary,
          ),
        if (acCost > 0)
          SavingsCategory(
            'AC / HVAC',
            acCost / totalCost * 100,
            t.primaryLight,
          ),
        if (equipmentCost > 0)
          SavingsCategory(
            'Equipment',
            equipmentCost / totalCost * 100,
            const Color(0xFFB8BDE3),
          ),
        if (machinesCost > 0)
          SavingsCategory(
            'Machines',
            machinesCost / totalCost * 100,
            const Color(0xFFD9DBED),
          ),
      ];
    }

    setState(() {
      _monthlyKwh = monthlyKwh;
      _currentCostJod = monthlyJod.values;
      _monthLabels = monthlyJod.labels;
      _donutCategories = categories;
      _totalSavingPercent = 20;
      _potentialAnnualSavingJod = totalCost * _savingsFactor;
      _tariffJodPerKwh = tariff;
      _loading = false;
    });
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Parses "May 2025" → DateTime(2025, 5). Returns null on failure.
  static DateTime? _parseMonthYear(String s) {
    const names = [
      'january',
      'february',
      'march',
      'april',
      'may',
      'june',
      'july',
      'august',
      'september',
      'october',
      'november',
      'december',
    ];
    final parts = s.toLowerCase().trim().split(RegExp(r'\s+'));
    if (parts.length < 2) return null;
    final mIdx = names.indexWhere((m) => parts[0].startsWith(m));
    if (mIdx < 0) return null;
    final year = int.tryParse(parts[1]);
    if (year == null) return null;
    return DateTime(year, mIdx + 1);
  }

  /// Calculates the effective tariff (JOD/kWh) from the bills data.
  /// Returns total bill amount divided by total energy consumed across all
  /// months that have both values. Returns 0 if data is insufficient.
  static double _calcTariffFromBills(Map<String, dynamic> projectInfo) {
    final rawBills = projectInfo['bills'] as List? ?? [];
    double totalBill = 0;
    double totalKwh = 0;
    for (final bill in rawBills) {
      final b = bill as Map;
      final amount = double.tryParse(b['billAmount']?.toString() ?? '') ?? 0.0;
      final kwh = double.tryParse(b['energyConsumed']?.toString() ?? '') ?? 0.0;
      if (amount > 0 && kwh > 0) {
        totalBill += amount;
        totalKwh += kwh;
      }
    }
    return totalKwh > 0 ? totalBill / totalKwh : 0.0;
  }

  /// Builds 12 chronologically-ordered monthly bill values (JOD) starting
  /// from the oldest bill, plus matching short month labels ("May", "Jun"…).
  /// Missing months are filled with the stored average monthly bill.
  static ({List<double> values, List<String> labels}) _buildMonthlyBills(
    Map<String, dynamic> projectInfo,
  ) {
    const abbr = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final avgBill =
        (projectInfo['averageMonthlyBill'] as num?)?.toDouble() ?? 0.0;
    final rawBills = projectInfo['bills'] as List? ?? [];

    // Parse all bills that have a valid date
    final billMap = <DateTime, double>{};
    for (final bill in rawBills) {
      final b = bill as Map;
      final amount = double.tryParse(b['billAmount']?.toString() ?? '') ?? 0.0;
      final dt = _parseMonthYear(b['month'] as String? ?? '');
      if (dt != null && amount > 0) billMap[dt] = amount;
    }

    // Determine start: earliest bill, or Jan of current year as fallback
    final DateTime start = billMap.isEmpty
        ? DateTime(DateTime.now().year, 1)
        : billMap.keys.reduce((a, b) => a.isBefore(b) ? a : b);

    final values = <double>[];
    final labels = <String>[];
    for (int i = 0; i < 12; i++) {
      final dt = DateTime(start.year, start.month + i);
      values.add(billMap[dt] ?? avgBill);
      labels.add(abbr[dt.month - 1]);
    }

    return (values: values, labels: labels);
  }

  /// Sum energyCost field across lighting / equipment / machines items.
  static double _sumEnergyCost(List<dynamic> items) {
    return items.fold(0.0, (sum, item) {
      final m = item as Map;
      return sum + (double.tryParse(m['energyCost']?.toString() ?? '') ?? 0.0);
    });
  }

  /// Compute AC energy cost from raw fields (matches project_summary_page).
  static double _acEnergyCost(List<dynamic> ac, double tariff) {
    double total = 0;
    for (final g in ac) {
      final m = g as Map;
      final acType = m['acType'] as int? ?? 0;
      double kwh = 0;
      if (acType == 0) {
        kwh =
            (double.tryParse(m['noOfUnits']?.toString() ?? '') ?? 0) *
            (double.tryParse(m['ratedPower']?.toString() ?? '') ?? 0) *
            (double.tryParse(m['yearlyHours']?.toString() ?? '') ?? 0);
      } else if (acType == 1) {
        kwh =
            (double.tryParse(m['noOfPackages']?.toString() ?? '') ?? 0) *
            (double.tryParse(m['packagePower']?.toString() ?? '') ?? 0) *
            (double.tryParse(m['packageHours']?.toString() ?? '') ?? 0);
      } else if (acType == 2) {
        kwh =
            (double.tryParse(m['chillerPower']?.toString() ?? '') ?? 0) *
            (double.tryParse(m['chillerHours']?.toString() ?? '') ?? 0);
      }
      total += kwh * tariff;
    }
    return total;
  }

  /// Compute a good maxY (next clean multiple above the data max).
  static double _niceMax(List<double> values, {double minMax = 100}) {
    final mx = values.fold(0.0, (a, b) => a > b ? a : b);
    if (mx <= 0) return minMax;
    final raw = mx * 1.25;
    final magnitude = (raw == 0) ? 1 : (raw.abs().toString().length - 1);
    final step = (magnitude <= 1) ? 10.0 : (10.0 * (10 * (magnitude - 2) + 1));
    return (raw / step).ceil() * step;
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final t = widget.theme ?? ChartTheme();
    final hasMonthlyData = _monthlyKwh.any((v) => v > 0);

    final List<double> kwhData = hasMonthlyData
        ? _monthlyKwh
        : List.filled(12, 0);
    final List<double> costData = hasMonthlyData
        ? _currentCostJod
        : List.filled(12, 0);
    final afterKwh = kwhData.map((v) => v * (1 - _savingsFactor)).toList();
    final afterCost = costData.map((v) => v * (1 - _savingsFactor)).toList();

    final double kwh2max = hasMonthlyData ? _niceMax(_monthlyKwh) : 2000.0;
    final double kwh2interval = hasMonthlyData
        ? (_niceMax(_monthlyKwh) / 4).ceilToDouble()
        : 500.0;
    final double costMax = hasMonthlyData ? _niceMax(_currentCostJod) : 4500.0;
    final double costInterval = hasMonthlyData
        ? (_niceMax(_currentCostJod) / 4).ceilToDouble()
        : 500.0;

    final Widget donut = SavingsDonutCard(
      theme: t,
      categories: _donutCategories,
      totalSavingPercent: _totalSavingPercent,
      potentialAnnualSavingJod: _potentialAnnualSavingJod,
    );

    final Widget consumption = AnnualConsumptionCard(
      theme: t,
      electricityKwh: kwhData,
      maxY: kwh2max,
      interval: kwh2interval,
      monthLabels: _monthLabels,
    );

    final Widget savings = PotentialSavingsCard(
      theme: t,
      beforeKwh: kwhData,
      afterKwh: afterKwh,
      maxY: kwh2max,
      interval: kwh2interval,
      monthLabels: _monthLabels,
    );

    final Widget costCard = EstimatedCostCard(
      theme: t,
      currentCost: costData,
      afterSavings: afterCost,
      tariffJodPerKwh: _tariffJodPerKwh,
      maxY: costMax,
      interval: costInterval,
      monthLabels: _monthLabels,
    );

    final cards = [donut, consumption, savings, costCard];

    const double cardHeight = 430;

    return LayoutBuilder(
      builder: (context, constraints) {
        final twoCol = constraints.maxWidth >= 720;
        // Each card is wrapped in a keyed RepaintBoundary so it can be
        // captured as a PNG for the PDF reports.
        Widget bounded(int i) =>
            RepaintBoundary(key: _chartKeys[i], child: cards[i]);

        if (!twoCol) {
          return Column(
            children: [
              for (int i = 0; i < cards.length; i++) ...[
                SizedBox(height: cardHeight, child: bounded(i)),
                if (i < cards.length - 1) SizedBox(height: widget.spacing),
              ],
            ],
          );
        }
        return Column(
          children: [
            SizedBox(
              height: cardHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: bounded(0)),
                  SizedBox(width: widget.spacing),
                  Expanded(child: bounded(1)),
                ],
              ),
            ),
            SizedBox(height: widget.spacing),
            SizedBox(
              height: cardHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: bounded(2)),
                  SizedBox(width: widget.spacing),
                  Expanded(child: bounded(3)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
