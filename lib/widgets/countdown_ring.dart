import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class CountdownRing extends StatelessWidget {
  final int totalSeconds;
  final int remainingSeconds;
  final String statusText;
  final String appliedTimeText;

  const CountdownRing({
    super.key,
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.statusText,
    required this.appliedTimeText,
  });

  String _formatDigitalTime(int seconds) {
    if (seconds <= 0) return '00:00:00';

    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;

    String pad(int n) => n.toString().padLeft(2, '0');

    if (hours > 0) {
      return '${pad(hours)}:${pad(minutes)}:${pad(secs)}';
    }
    return '${pad(minutes)}:${pad(secs)}';
  }

  Color _getProgressColor(double progress) {
    if (progress > 0.5) return AppTheme.statusSuccess;
    if (progress > 0.2) return AppTheme.statusWarning;
    return AppTheme.statusDanger;
  }

  @override
  Widget build(BuildContext context) {
    final double progress = totalSeconds > 0
        ? (remainingSeconds / totalSeconds).clamp(0.0, 1.0)
        : 0.0;

    final progressColor = _getProgressColor(progress);

    return Column(
      children: [
        SizedBox(
          width: 260,
          height: 260,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Circular Progress Ring Custom Painter
              CustomPaint(
                size: const Size(260, 260),
                painter: _RingPainter(
                  progress: progress,
                  activeColor: progressColor,
                  backgroundColor: Colors.black.withOpacity(0.08),
                ),
              ),

              // Center Digital Timer Display
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🧴', style: TextStyle(fontSize: 36)),
                  const SizedBox(height: 4),
                  Text(
                    _formatDigitalTime(remainingSeconds),
                    style: GoogleFonts.outfit(
                      fontSize: remainingSeconds >= 3600 ? 36 : 44,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.deepNavy,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: progressColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      remainingSeconds > 0 ? statusText : 'Reapplication Due! ⚡',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: progressColor == AppTheme.statusSuccess
                            ? const Color(0xFF15803D)
                            : progressColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          appliedTimeText,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.deepNavy.withOpacity(0.75),
          ),
        ),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color backgroundColor;

  _RingPainter({
    required this.progress,
    required this.activeColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 24) / 2;
    const strokeWidth = 18.0;

    // Background track
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Active progress arc
    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [
          activeColor.withOpacity(0.6),
          activeColor,
        ],
        startAngle: -pi / 2,
        endAngle: -pi / 2 + (2 * pi * progress),
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor;
  }
}
