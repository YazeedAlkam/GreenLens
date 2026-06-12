import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'chart_theme.dart';

/// Chart card comparing before- and after-implementation monthly kWh as a grouped bar chart.
class PotentialSavingsCard extends StatelessWidget {
  final ChartTheme theme;

  /// 12 values (Jan..Dec) in kWh.
  final List<double> beforeKwh;
  final List<double> afterKwh;
  final double maxY;
  final double interval;

  /// Optional x-axis labels (12 short month strings e.g. "May", "Jun"…).
  final List<String>? monthLabels;

  const PotentialSavingsCard({
    super.key,
    required this.theme,
    required this.beforeKwh,
    required this.afterKwh,
    this.maxY = 2000,
    this.interval = 500,
    this.monthLabels,
  })  : assert(beforeKwh.length == 12),
        assert(afterKwh.length == 12);

  /// Creates a [PotentialSavingsCard] pre-filled with hard-coded sample data for previews.
  factory PotentialSavingsCard.sample(ChartTheme theme) {
    return PotentialSavingsCard(
      theme: theme,
      beforeKwh: const [
        917, 958, 1000, 1083, 1375, 1625, 1750, 1792, 1667, 1333, 1083, 1042,
      ],
      afterKwh: const [
        733, 767, 800, 867, 1100, 1300, 1400, 1433, 1333, 1067, 867, 833,
      ],
      maxY: 2000,
      interval: 500,
    );
  }

  @override
  Widget build(BuildContext context) {
    final beforeColor = theme.primary;
    final afterColor = theme.warning;

    return ChartCard(
      title: 'Potential Savings',
      subtitle: '(kWh/Year)',
      theme: theme,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL ENERGY CONSUMPTION (kWh)',
                    style: theme.sectionTitleStyle.copyWith(fontSize: 10),
                  ),
                  Text(
                    'BEFORE vs. AFTER IMPLEMENTATION',
                    style: theme.sectionTitleStyle.copyWith(fontSize: 10),
                  ),
                ],
              ),
              Row(
                children: [
                  LegendDot(
                    square: true,
                    color: beforeColor,
                    label: 'BEFORE (kWh)',
                    style: theme.legendStyle.copyWith(fontSize: 11),
                  ),
                  const SizedBox(width: 10),
                  LegendDot(
                    square: true,
                    color: afterColor,
                    label: 'AFTER (kWh)',
                    style: theme.legendStyle.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
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
                        _rod(beforeKwh[i], beforeColor),
                        _rod(afterKwh[i], afterColor),
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
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: interval,
                      getTitlesWidget: (v, _) => Text(
                        v.toInt().toString(),
                        style: theme.axisLabelStyle,
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
                          child: Text(
                            (monthLabels ?? ChartTheme.months)[i].toUpperCase(),
                            style: theme.axisLabelStyle,
                          ),
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
                        horizontal: 10, vertical: 6),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                        BarTooltipItem(
                      '${rod.toY.toInt()} kWh',
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
        ],
      ),
    );
  }

  /// Builds a single bar rod with rounded top corners.
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
}
