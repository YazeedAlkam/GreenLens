import 'package:flutter/material.dart';

class StepperDemo extends StatefulWidget {
  const StepperDemo({super.key});

  @override
  State<StepperDemo> createState() => _StepperDemoState();
}

class _StepperDemoState extends State<StepperDemo> {
  int _currentStep = 0;

  final List<String> _steps = [
    'Client Info',
    'Project Info',
    'Assign Engineers',
    'Costs',
    'Review',
  ];

  void _next() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    }
  }

  void _back() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A237E),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Text(
                  _steps[_currentStep],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          _buildStepper(),
          const SizedBox(height: 16),
          _buildProgressBar(),
          const SizedBox(height: 12),
          _buildButtons(),
        ],
      ),
    );
  }

  // ================= STEPPER =================

  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.only(left: 85), // ✅ FIXED SAFE OFFSET
      child: Row(
        children: List.generate(_steps.length, (index) {
          return Expanded(
            child: Row(
              children: [
                _buildStep(index),

                if (index < _steps.length - 1)
                  Expanded(child: _buildConnector(index)),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ================= STEP =================

  Widget _buildStep(int index) {
    final isActive = index == _currentStep;
    final isCompleted = index < _currentStep;

    return GestureDetector(
      onTap: () => setState(() => _currentStep = index),
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
            width: 90,
            child: Text(
              _steps[index],
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
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

  Widget _buildConnector(int index) {
    final isActive = index < _currentStep;

    return Container(
      margin: const EdgeInsets.only(bottom: 28),
      child: Row(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: 2,
              decoration: BoxDecoration(
                color: isActive
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

  Widget _buildProgressBar() {
    final progress = _currentStep / (_steps.length - 1);

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

  // ================= BUTTONS =================

  Widget _buildButtons() {
    final isLast = _currentStep == _steps.length - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: _currentStep > 0 ? _back : null,
          style: TextButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            foregroundColor: Colors.white,
          ),
          child: const Text('Back'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: isLast ? null : _next,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
          ),
          child: Text(isLast ? 'Submit' : 'Next'),
        ),
      ],
    );
  }
}
