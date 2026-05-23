import 'package:flutter/material.dart';
import 'annual_consumption_card.dart';
import 'chart_theme.dart';
import 'estimated_cost_card.dart';
import 'potential_savings_card.dart';
import 'savings_donut_card.dart';

/// 2x2 grid of all four project charts. Currently populated with sample data;
/// swap factory constructors for data-driven ones once Firestore sources exist.
class ProjectChartsGrid extends StatelessWidget {
  final ChartTheme? theme;
  final double spacing;

  const ProjectChartsGrid({
    super.key,
    this.theme,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    final t = theme ?? ChartTheme();

    final cards = [
      SavingsDonutCard.sample(t),
      AnnualConsumptionCard.sample(t),
      PotentialSavingsCard.sample(t),
      EstimatedCostCard.sample(t),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final twoCol = constraints.maxWidth >= 720;
        if (!twoCol) {
          return Column(
            children: [
              for (int i = 0; i < cards.length; i++) ...[
                cards[i],
                if (i < cards.length - 1) SizedBox(height: spacing),
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
                SizedBox(width: spacing),
                Expanded(child: cards[1]),
              ],
            ),
            SizedBox(height: spacing),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: cards[2]),
                SizedBox(width: spacing),
                Expanded(child: cards[3]),
              ],
            ),
          ],
        );
      },
    );
  }
}
