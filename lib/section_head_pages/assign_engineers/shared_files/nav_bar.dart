import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Two-step nav bar for the Assign Engineers flow
/// (Select Project → Select Engineer).
class AssignEngNavBar extends StatelessWidget {
  final int currentStep;
  final ValueChanged<int>? onStepTapped;

  const AssignEngNavBar({
    super.key,
    required this.currentStep,
    this.onStepTapped,
  });

  final List<String> _steps = const ['Select Project', 'Select Engineer'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 450,
      child: Column(
        children: [
          _buildStepper(),
          const SizedBox(height: 12),
          _buildProgressBar(),
        ],
      ),
    );
  }

  /// Lays out the step circles with connector lines between them:
  /// even indexes are steps, odd indexes are connectors.
  Widget _buildStepper() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: List.generate(_steps.length * 2 - 1, (i) {
        if (i.isEven) {
          return _buildStep(i ~/ 2);
        } else {
          return Expanded(child: _buildConnector(i ~/ 2));
        }
      }),
    );
  }

  /// One numbered circle + label. Completed steps show a check mark,
  /// the active step is highlighted white, future steps are dimmed.
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
                      style: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? const Color(0xFF1A237E)
                            : Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 150,
            child: Text(
              _steps[index],
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.firaSans(
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

  /// Thin line between two step circles; brightens once the step before
  /// it is completed.
  Widget _buildConnector(int index) {
    final isCompleted = index < currentStep;

    return Container(
      margin: const EdgeInsets.only(bottom: 28),
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
    );
  }

  /// Animated green progress bar under the stepper showing overall
  /// completion (step+1 / total).
  Widget _buildProgressBar() {
    final progress = (currentStep + 1) / _steps.length;

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
