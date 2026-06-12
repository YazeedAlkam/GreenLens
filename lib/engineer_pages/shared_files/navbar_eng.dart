import 'package:flutter/material.dart';

/// Step-indicator nav bar for the engineer audit entry wizard.
///
/// Renders the six wizard steps (Building → Review) as numbered circles
/// connected by animated lines, plus a linear progress bar. Tapping a circle
/// fires [onStepTapped] so the parent can jump to that step.
class NavigationBarLinesEng extends StatelessWidget {
  final int currentStep;
  final ValueChanged<int>? onStepTapped;

  const NavigationBarLinesEng({
    super.key,
    required this.currentStep,
    this.onStepTapped,
  });

  final List<String> _steps = const [
    'Building',
    'Lighting',
    'AC',
    'Equipment',
    'Production',
    'Review',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStepper(),
        const SizedBox(height: 12),
        _buildProgressBar(),
      ],
    );
  }

  // ================= STEPPER =================

  /// Builds the row of step circles connected by animated connector lines.
  Widget _buildStepper() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: List.generate(_steps.length * 2 - 1, (i) {
        if (i.isEven) {
          final index = i ~/ 2;
          return _buildStep(index); // ❌ no Expanded here
        } else {
          final index = i ~/ 2;
          return Expanded(
            child: _buildConnector(index),
          ); // ✅ only connectors expand
        }
      }),
    );
  }

  // ================= STEP =================

  /// Builds one step circle with label. Active steps are filled; completed
  /// steps show a check mark; future steps are outlined.
  Widget _buildStep(int index) {
    final isActive = index == currentStep;
    final isCompleted = index < currentStep;

    return GestureDetector(
      onTap: () => onStepTapped?.call(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? Colors.white
                  : isCompleted
                  ? Colors.white.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.15),
              border: Border.all(
                color: isCompleted
                    ? Colors.white.withValues(alpha: 0.6)
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isActive
                            ? const Color(0xFF1A237E)
                            : Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 100,
            child: Text(
              _steps[index],
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? Colors.white
                    : isCompleted
                    ? Colors.white.withValues(alpha: 0.7)
                    : Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= CONNECTOR =================

  /// Builds the animated horizontal line between two step circles.
  Widget _buildConnector(int index) {
    final isCompleted = index < currentStep;

    return Container(
      margin: const EdgeInsets.only(bottom: 28),
      child: Row(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: 2,
              decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.white.withValues(alpha: 0.7)
                    : Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= PROGRESS =================

  /// Builds the animated linear progress bar beneath the step circles.
  Widget _buildProgressBar() {
    final progress = (currentStep + 1) / (_steps.length);

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: progress),
        duration: const Duration(milliseconds: 400),
        builder: (context, value, _) {
          return LinearProgressIndicator(
            value: value,
            minHeight: 5,
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
          );
        },
      ),
    );
  }
}
