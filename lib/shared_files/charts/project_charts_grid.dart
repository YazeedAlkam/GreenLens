import 'package:flutter/material.dart';
import 'package:greenlens/firebase/project_service.dart';
import 'package:greenlens/main.dart';
import 'annual_consumption_card.dart';
import 'chart_theme.dart';
import 'estimated_cost_card.dart';
import 'potential_savings_card.dart';
import 'savings_donut_card.dart';

const double _savingsFactor = 0.20;

class ProjectChartsGrid extends StatefulWidget {
  final String? projectId;
  final ChartTheme? theme;
  final double spacing;

  const ProjectChartsGrid({
    super.key,
    this.projectId,
    this.theme,
    this.spacing = 12,
  });

  @override
  State<ProjectChartsGrid> createState() => _ProjectChartsGridState();
}

class _ProjectChartsGridState extends State<ProjectChartsGrid> {
  bool _loading = true;

  // Chart 1 — Savings Donut
  List<SavingsCategory> _donutCategories = [];
  double _totalSavingPercent = 20;
  double _potentialAnnualSavingJod = 0;

  // Charts 2, 3, 4 — monthly data (12 values)
  List<double> _monthlyKwh = List.filled(12, 0);
  List<double> _currentCostJod = List.filled(12, 0);

  @override
  void initState() {
    super.initState();
    _load();
  }

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
    final monthlyKwh = monthlyJod.map((v) => v / energyTariffJodPerKwh).toList();

    // ── Energy cost per system (for donut) ────────────────────────────────────
    final lighting = auditData['lighting'] as List? ?? [];
    final ac = auditData['ac'] as List? ?? [];
    final equipment = auditData['equipment'] as List? ?? [];
    final machines = auditData['machines'] as List? ?? [];

    final lightingCost = _sumEnergyCost(lighting);
    final acCost = _acEnergyCost(ac);
    final equipmentCost = _sumEnergyCost(equipment);
    final machinesCost = _sumEnergyCost(machines);
    final totalCost = lightingCost + acCost + equipmentCost + machinesCost;

    List<SavingsCategory> categories = [];
    if (totalCost > 0) {
      final t = ChartTheme();
      categories = [
        if (lightingCost > 0)
          SavingsCategory(
              'Lighting', lightingCost / totalCost * 100, t.primary),
        if (acCost > 0)
          SavingsCategory('AC / HVAC', acCost / totalCost * 100, t.primaryLight),
        if (equipmentCost > 0)
          SavingsCategory(
              'Equipment', equipmentCost / totalCost * 100, const Color(0xFFB8BDE3)),
        if (machinesCost > 0)
          SavingsCategory(
              'Machines', machinesCost / totalCost * 100, const Color(0xFFD9DBED)),
      ];
    }

    setState(() {
      _monthlyKwh = monthlyKwh;
      _currentCostJod = monthlyJod;
      _donutCategories = categories;
      _totalSavingPercent = 20;
      _potentialAnnualSavingJod = totalCost * _savingsFactor;
      _loading = false;
    });
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Maps month name string like "January 2025" → 0-based index (0=Jan).
  static int _monthIndex(String monthStr) {
    const months = [
      'january', 'february', 'march', 'april', 'may', 'june',
      'july', 'august', 'september', 'october', 'november', 'december'
    ];
    final lower = monthStr.toLowerCase();
    for (int i = 0; i < months.length; i++) {
      if (lower.startsWith(months[i])) return i;
    }
    return -1;
  }

  /// Builds a 12-element monthly bill list (JOD). Missing months are filled
  /// with the average monthly bill from projectInfo.
  static List<double> _buildMonthlyBills(Map<String, dynamic> projectInfo) {
    final avgBill =
        (projectInfo['averageMonthlyBill'] as num?)?.toDouble() ?? 0.0;
    final rawBills = projectInfo['bills'] as List? ?? [];

    final result = List<double>.filled(12, 0.0);
    for (final bill in rawBills) {
      final b = bill as Map;
      final amount =
          double.tryParse(b['billAmount']?.toString() ?? '') ?? 0.0;
      if (amount <= 0) continue;
      final idx = _monthIndex(b['month'] as String? ?? '');
      if (idx >= 0) result[idx] = amount;
    }

    // Fill unset months with the stored average
    if (avgBill > 0) {
      for (int i = 0; i < 12; i++) {
        if (result[i] == 0) result[i] = avgBill;
      }
    }

    return result;
  }

  /// Sum energyCost field across lighting / equipment / machines items.
  static double _sumEnergyCost(List<dynamic> items) {
    return items.fold(0.0, (sum, item) {
      final m = item as Map;
      return sum +
          (double.tryParse(m['energyCost']?.toString() ?? '') ?? 0.0);
    });
  }

  /// Compute AC energy cost from raw fields (matches project_summary_page).
  static double _acEnergyCost(List<dynamic> ac) {
    double total = 0;
    for (final g in ac) {
      final m = g as Map;
      final acType = m['acType'] as int? ?? 0;
      double kwh = 0;
      if (acType == 0) {
        kwh = (double.tryParse(m['noOfUnits']?.toString() ?? '') ?? 0) *
            (double.tryParse(m['ratedPower']?.toString() ?? '') ?? 0) *
            (double.tryParse(m['yearlyHours']?.toString() ?? '') ?? 0);
      } else if (acType == 1) {
        kwh = (double.tryParse(m['noOfPackages']?.toString() ?? '') ?? 0) *
            (double.tryParse(m['packagePower']?.toString() ?? '') ?? 0) *
            (double.tryParse(m['packageHours']?.toString() ?? '') ?? 0);
      } else if (acType == 2) {
        kwh = (double.tryParse(m['chillerPower']?.toString() ?? '') ?? 0) *
            (double.tryParse(m['chillerHours']?.toString() ?? '') ?? 0);
      }
      total += kwh * energyTariffJodPerKwh;
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
    final afterKwh = _monthlyKwh.map((v) => v * (1 - _savingsFactor)).toList();
    final afterCost =
        _currentCostJod.map((v) => v * (1 - _savingsFactor)).toList();

    final kwh2max = _niceMax(_monthlyKwh);
    final kwh2interval = (kwh2max / 4).ceilToDouble();
    final costMax = _niceMax(_currentCostJod);
    final costInterval = (costMax / 4).ceilToDouble();

    // Use sample data for donut when no audit data
    final SavingsDonutCard donut = _donutCategories.isEmpty
        ? SavingsDonutCard.sample(t)
        : SavingsDonutCard(
            theme: t,
            categories: _donutCategories,
            totalSavingPercent: _totalSavingPercent,
            potentialAnnualSavingJod: _potentialAnnualSavingJod,
          );

    final hasMonthlyData = _monthlyKwh.any((v) => v > 0);

    final AnnualConsumptionCard consumption = hasMonthlyData
        ? AnnualConsumptionCard(
            theme: t,
            electricityKwh: _monthlyKwh,
            maxY: kwh2max,
            interval: kwh2interval,
          )
        : AnnualConsumptionCard.sample(t);

    final PotentialSavingsCard savings = hasMonthlyData
        ? PotentialSavingsCard(
            theme: t,
            beforeKwh: _monthlyKwh,
            afterKwh: afterKwh,
            maxY: kwh2max,
            interval: kwh2interval,
          )
        : PotentialSavingsCard.sample(t);

    final EstimatedCostCard costCard = hasMonthlyData
        ? EstimatedCostCard(
            theme: t,
            currentCost: _currentCostJod,
            afterSavings: afterCost,
            maxY: costMax,
            interval: costInterval,
          )
        : EstimatedCostCard.sample(t);

    final cards = [donut, consumption, savings, costCard];

    return LayoutBuilder(
      builder: (context, constraints) {
        final twoCol = constraints.maxWidth >= 720;
        if (!twoCol) {
          return Column(
            children: [
              for (int i = 0; i < cards.length; i++) ...[
                cards[i],
                if (i < cards.length - 1) SizedBox(height: widget.spacing),
              ],
            ],
          );
        }
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: cards[0]),
                SizedBox(width: widget.spacing),
                Expanded(child: cards[1]),
              ],
            ),
            SizedBox(height: widget.spacing),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: cards[2]),
                SizedBox(width: widget.spacing),
                Expanded(child: cards[3]),
              ],
            ),
          ],
        );
      },
    );
  }
}
