import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'chart_theme.dart';

class AnnualConsumptionCard extends StatelessWidget {
  final ChartTheme theme;

  /// 12 values (Jan..Dec) in kWh.
  final List<double> electricityKwh;
  final double maxY;
  final double interval;

  const AnnualConsumptionCard({
    super.key,
    required this.theme,
    required this.electricityKwh,
    this.maxY = 2000,
    this.interval = 500,
  }) : assert(electricityKwh.length == 12);

  factory AnnualConsumptionCard.sample(ChartTheme theme) {
    return AnnualConsumptionCard(
      theme: theme,
      electricityKwh: const [
        917, 958, 1000, 1083, 1375, 1625, 1750, 1792, 1667, 1333, 1083, 1042,
      ],
      maxY: 2000,
      interval: 500,
    );
  }

  @override
  Widget build(BuildContext context) {
    final electricityColor = theme.primary;

    return ChartCard(
      title: 'Total Annual Consumption',
      subtitle: '(kWh/Year)',
      theme: theme,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GRID ELECTRICITY USAGE BY MONTH',
                style: theme.sectionTitleStyle.copyWith(fontSize: 11),
              ),
              LegendDot(
                color: electricityColor,
                label: 'Electricity (kWh)',
                style: theme.legendStyle.copyWith(fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: maxY,
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
                      getTitlesWidget: (v, _) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Text(
                          v.toInt().toString(),
                          style: theme.axisLabelStyle,
                        ),
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
                            ChartTheme.months[i].toUpperCase(),
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
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => Colors.white,
                    tooltipBorder: BorderSide(color: theme.cardBorder),
                  ),
                ),
                lineBarsData: [
                  _series(electricityKwh, electricityColor, fillAlpha: 0.18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartBarData _series(List<double> data, Color color,
      {double fillAlpha = 0.2}) {
    return LineChartBarData(
      spots: [
        for (int i = 0; i < data.length; i++) FlSpot(i.toDouble(), data[i]),
      ],
      isCurved: true,
      curveSmoothness: 0.25,
      color: color,
      barWidth: 2.5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, a, b, c) => FlDotCirclePainter(
          radius: 3,
          color: Colors.white,
          strokeColor: color,
          strokeWidth: 2,
        ),
      ),
      belowBarData: BarAreaData(
        show: true,
        color: color.withValues(alpha: fillAlpha),
      ),
    );
  }
}
