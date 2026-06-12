import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'chart_theme.dart';

/// Immutable data class for one donut segment: a label, percentage value, and color.
class SavingsCategory {
  final String label;
  final double percent;
  final Color color;
  const SavingsCategory(this.label, this.percent, this.color);
}

/// Chart card showing a donut pie chart of savings by energy system,
/// per-system progress bars, and a total potential annual saving summary row.
class SavingsDonutCard extends StatelessWidget {
  final ChartTheme theme;
  final List<SavingsCategory> categories;
  final double totalSavingPercent;
  final double potentialAnnualSavingJod;

  const SavingsDonutCard({
    super.key,
    required this.theme,
    required this.categories,
    required this.totalSavingPercent,
    required this.potentialAnnualSavingJod,
  });

  /// Creates a [SavingsDonutCard] pre-filled with hard-coded sample data for previews.
  factory SavingsDonutCard.sample(ChartTheme theme) {
    return SavingsDonutCard(
      theme: theme,
      totalSavingPercent: 31,
      potentialAnnualSavingJod: 11904,
      categories: [
        SavingsCategory('Lighting', 38, theme.primary),
        SavingsCategory('AC / HVAC', 25, theme.primaryLight),
        SavingsCategory('Equipment', 18, const Color(0xFFB8BDE3)),
        SavingsCategory('Other', 19, const Color(0xFFD9DBED)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = categories.isEmpty;
    final sections = isEmpty
        ? [PieChartSectionData(value: 1, color: theme.axisLine, radius: 22, showTitle: false)]
        : categories
            .map((c) => PieChartSectionData(
                  value: c.percent,
                  color: c.color,
                  radius: 22,
                  showTitle: false,
                ))
            .toList();

    return ChartCard(
      title: 'Savings as % of Total Consumption',
      theme: theme,
      child: Column(
        children: [
          Text('Savings as % of total consumption', style: theme.sectionTitleStyle),
          Text('Potential reduction per energy system', style: theme.footnoteStyle),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 130,
                height: 130,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 38,
                        startDegreeOffset: -90,
                        sections: sections,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isEmpty ? '—' : '${totalSavingPercent.toStringAsFixed(0)}%',
                          style: theme.titleStyle.copyWith(
                            fontSize: 22,
                            color: isEmpty ? theme.textMuted : theme.primary,
                          ),
                        ),
                        Text('total saving',
                            style: theme.footnoteStyle.copyWith(
                                fontStyle: FontStyle.normal)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: isEmpty
                    ? Center(
                        child: Text('No data yet',
                            style: theme.axisLabelStyle
                                .copyWith(color: theme.textMuted)),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final c in categories) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: LegendDot(
                                    color: c.color,
                                    label: c.label,
                                    style: theme.legendStyle,
                                  ),
                                ),
                                Text('${c.percent.toStringAsFixed(0)}%',
                                    style: theme.legendStyle),
                              ],
                            ),
                            const SizedBox(height: 4),
                          ],
                        ],
                      ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (!isEmpty)
            for (final c in categories) ...[
              _BarRow(category: c, theme: theme),
              const SizedBox(height: 6),
            ],
          const Spacer(),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF1FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Potential annual saving', style: theme.legendStyle),
                Text(
                  isEmpty ? '—' : '${_formatNumber(potentialAnnualSavingJod)} JOD / year',
                  style: theme.legendStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isEmpty ? theme.textMuted : theme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Formats a double to a comma-separated integer string for the annual saving display.
  static String _formatNumber(double v) {
    final s = v.truncateToDouble() == v
        ? v.toInt().toString()
        : v.toStringAsFixed(0);
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final remaining = s.length - i;
      buf.write(s[i]);
      if (remaining > 1 && remaining % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }
}

/// Renders one savings category row: a label, a proportional progress bar, and a percentage.
class _BarRow extends StatelessWidget {
  final SavingsCategory category;
  final ChartTheme theme;
  const _BarRow({required this.category, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(category.label, style: theme.axisLabelStyle.copyWith(
            color: theme.textPrimary,
          )),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: theme.axisLine,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: (category.percent / 100).clamp(0.0, 1.0),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: category.color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 36,
          child: Text(
            '${category.percent.toStringAsFixed(0)}%',
            textAlign: TextAlign.right,
            style: theme.legendStyle,
          ),
        ),
      ],
    );
  }
}
