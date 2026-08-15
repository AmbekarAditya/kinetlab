import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../utils/sun_algorithm.dart';

class UvBadge extends StatelessWidget {
  final double uvi;
  final bool showLabel;

  const UvBadge({
    super.key,
    required this.uvi,
    this.showLabel = true,
  });

  Color _getUvColor(double uvi) {
    if (uvi >= 11.0) return AppTheme.statusDanger;
    if (uvi >= 8.0) return const Color(0xFFFF5252);
    if (uvi >= 6.0) return AppTheme.statusWarning;
    if (uvi >= 3.0) return const Color(0xFFFACC15);
    return AppTheme.statusSuccess;
  }

  @override
  Widget build(BuildContext context) {
    final bool isHighUv = uvi >= 6.0;
    final color = _getUvColor(uvi);
    final category = getUvCategory(uvi);

    Widget badgeContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: isHighUv
            ? [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'UV ${uvi.toStringAsFixed(1)}',
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          if (showLabel) ...[
            const SizedBox(width: 8),
            Text(
              category,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.deepNavy,
              ),
            ),
          ],
        ],
      ),
    );

    // Apply pulsing scale/glow microinteraction when UVI >= 6.0
    if (isHighUv) {
      return badgeContent.animate(
        onPlay: (controller) => controller.repeat(reverse: true),
      ).scale(
        duration: 1200.ms,
        begin: const Offset(1.0, 1.0),
        end: const Offset(1.05, 1.05),
        curve: Curves.easeInOut,
      );
    }

    return badgeContent;
  }
}
