import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../utils/sun_algorithm.dart';
import 'glass_card.dart';

class SkinStressMeter extends StatelessWidget {
  final double uvi;
  final double tempCelsius;
  final double humidityPercent;
  final bool isOutdoor;
  final bool isHighSweatRisk;

  const SkinStressMeter({
    super.key,
    required this.uvi,
    required this.tempCelsius,
    required this.humidityPercent,
    required this.isOutdoor,
    required this.isHighSweatRisk,
  });

  Color _getStressColor(double score) {
    if (score >= 70) return AppTheme.statusDanger;
    if (score >= 40) return AppTheme.statusWarning;
    return AppTheme.statusSuccess;
  }

  String _getStressLabel(double score) {
    if (score >= 75) return 'Extreme Stress ⚡';
    if (score >= 50) return 'High Stress 🔥';
    if (score >= 30) return 'Moderate Stress 🌤️';
    return 'Low Stress 🌿';
  }

  @override
  Widget build(BuildContext context) {
    final score = calculateSkinStressScore(
      uvi: uvi,
      tempCelsius: tempCelsius,
      humidityPercent: humidityPercent,
      isOutdoor: isOutdoor,
      isHighSweatRisk: isHighSweatRisk,
    );

    final color = _getStressColor(score);
    final label = _getStressLabel(score);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('🧬', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    'Skin Stress Index',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.deepNavy,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.4)),
                ),
                child: Text(
                  '${score.toInt()}%',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Apple Health Style Segmented Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 14,
              child: Stack(
                children: [
                  // Track background
                  Container(
                    color: Colors.black.withOpacity(0.06),
                  ),

                  // Progress Fill
                  FractionallySizedBox(
                    widthFactor: (score / 100.0).clamp(0.02, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.statusSuccess,
                            if (score >= 40) AppTheme.statusWarning,
                            if (score >= 70) AppTheme.statusDanger,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Segment Dividers (Apple Health style tick marks)
                  Row(
                    children: List.generate(
                      10,
                      (index) => Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.white.withOpacity(0.6),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.deepNavy.withOpacity(0.9),
                ),
              ),
              Text(
                isOutdoor ? 'Outdoor Exposure' : 'Indoor Protected',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppTheme.deepNavy.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
