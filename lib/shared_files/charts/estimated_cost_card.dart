import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'chart_theme.dart';

class EstimatedCostCard extends StatelessWidget {
  final ChartTheme theme;

  /// 12 values per series (Jan..Dec) in JOD.
  final List<double> currentCost;
  final List<double> afterSavings;
  final double tariffJodPerKwh;
  final double maxY;
  final double interval;

  const EstimatedCostCard({
    super.key,
    required this.theme,
    required this.currentCost,
    required this.afterSavings,
    this.tariffJodPerKwh = 0.32,
    this.maxY = 4500,
    this.interval = 500,
  })  : assert(currentCost.length == 12),
        assert(afterSavings.length == 12);

  factory EstimatedCostCard.sample(ChartTheme theme) {
    return EstimatedCostCard(
      theme: theme,
      currentCost: const [3200, 3300, 3000, 3300, 3700, 3900, 4000, 4000, 3600, 3300, 3100, 3000],
      afterSavings: const [2400, 2500, 2300, 2500, 2700, 2900, 3000, 3000, 2700, 2500, 2300, 2200],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = theme.primary;
    final afterColor = theme.accent;
    final total = currentCost.fold<double>(0, (a, b) => a + b);

    return ChartCard(
      title: 'Estimated Annual Cost',
      subtitle: '(JOD/year)',
      theme: theme,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Estimated annual cost', style: theme.sectionTitleStyle),
          Text('(JOD / year)', style: theme.footnoteStyle),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: theme.accentSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text('Total: ${_formatNumber(total)} JOD/year',
                    style: theme.legendStyle.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LegendDot(square: true, color: currentColor, label: 'Current cost', style: theme.legendStyle.copyWith(fontSize: 11)),
              const SizedBox(width: 14),
              LegendDot(square: true, color: afterColor, label: 'After savings', style: theme.legendStyle.copyWith(fontSize: 11)),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barGroups: [
                  for (int i = 0; i < 12; i++)
                    BarChartGroupData(
                      x: i,
                      barsSpace: 2,
                      barRods: [
                        _rod(currentCost[i], currentColor),
                        _rod(afterSavings[i], afterColor),
                      ],
                    ),
                ],
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: interval,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: theme.axisLine,
                    strokeWidth: 1,
                    dashArray: const [4, 4],
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 48,
                      interval: interval,
                      getTitlesWidget: (v, _) => Text(
                        '${v.toInt()} JOD',
                        style: theme.axisLabelStyle.copyWith(fontSize: 9),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 1,
                      getTitlesWidget: (v, _) {
                        final i = v.toInt();
                        if (i < 0 || i > 11) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(ChartTheme.months[i],
                              style: theme.axisLabelStyle),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: theme.axisLine),
                    left: BorderSide(color: theme.axisLine),
                  ),
                ),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => Colors.white,
                    tooltipBorder: BorderSide(color: theme.cardBorder),
                    tooltipBorderRadius: BorderRadius.circular(8),
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                        BarTooltipItem(
                      '${rod.toY.toInt()} JOD',
                      theme.valueLabelStyle.copyWith(
                        color: theme.textPrimary,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Electricity tariff: ${tariffJodPerKwh.toStringAsFixed(2)} JOD/kWh · Based on audit data',
            style: theme.footnoteStyle,
          ),
        ],
      ),
    );
  }

  BarChartRodData _rod(double value, Color color) {
    return BarChartRodData(
      toY: value,
      color: color,
      width: 7,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(2),
        topRight: Radius.circular(2),
      ),
    );
  }

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
