import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central styling for all project charts. Tweak once, every chart updates.
class ChartTheme {
  final Color primary;
  final Color primaryLight;
  final Color accent;
  final Color accentSoft;
  final Color warning;
  final Color warningSoft;
  final Color textPrimary;
  final Color textMuted;
  final Color axisLine;
  final Color cardBackground;
  final Color cardBorder;
  final double cardRadius;

  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final TextStyle sectionTitleStyle;
  final TextStyle legendStyle;
  final TextStyle valueLabelStyle;
  final TextStyle axisLabelStyle;
  final TextStyle footnoteStyle;

  ChartTheme({
    this.primary = const Color(0xFF1A237E),
    this.primaryLight = const Color(0xFF8A90CE),
    this.accent = const Color(0xFF4CAF50),
    this.accentSoft = const Color(0xFFC9E7CB),
    this.warning = const Color(0xFFEB9D4A),
    this.warningSoft = const Color(0xFFFFD9A8),
    this.textPrimary = const Color(0xFF1A1A1A),
    this.textMuted = const Color(0xFF808080),
    this.axisLine = const Color(0xFFE0E0E0),
    this.cardBackground = Colors.white,
    this.cardBorder = const Color(0xFFE5E5E5),
    this.cardRadius = 16,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    TextStyle? sectionTitleStyle,
    TextStyle? legendStyle,
    TextStyle? valueLabelStyle,
    TextStyle? axisLabelStyle,
    TextStyle? footnoteStyle,
  })  : titleStyle = titleStyle ??
            GoogleFonts.firaSans(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
        subtitleStyle = subtitleStyle ??
            GoogleFonts.firaSans(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1A1A1A),
            ),
        sectionTitleStyle = sectionTitleStyle ??
            GoogleFonts.firaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A237E),
            ),
        legendStyle = legendStyle ??
            GoogleFonts.firaSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1A1A1A),
            ),
        valueLabelStyle = valueLabelStyle ??
            GoogleFonts.firaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
        axisLabelStyle = axisLabelStyle ??
            GoogleFonts.firaSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF808080),
            ),
        footnoteStyle = footnoteStyle ??
            GoogleFonts.firaSans(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: const Color(0xFF808080),
            );

  BoxDecoration get cardDecoration => BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(cardRadius),
        border: Border.all(color: cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      );

  static const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
}

/// Small coloured dot + label used in chart legends.
class LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final TextStyle? style;
  final bool square;
  const LegendDot({
    super.key,
    required this.color,
    required this.label,
    this.style,
    this.square = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: square ? BoxShape.rectangle : BoxShape.circle,
            borderRadius: square ? BorderRadius.circular(2) : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: style),
      ],
    );
  }
}

/// Reusable card wrapper used by every chart card.
class ChartCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final ChartTheme theme;
  final EdgeInsetsGeometry padding;

  const ChartCard({
    super.key,
    required this.title,
    required this.child,
    required this.theme,
    this.subtitle,
    this.padding = const EdgeInsets.fromLTRB(16, 14, 16, 14),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: theme.cardDecoration,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: theme.titleStyle, textAlign: TextAlign.center),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(subtitle!, style: theme.subtitleStyle, textAlign: TextAlign.center),
          ],
          const SizedBox(height: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}
