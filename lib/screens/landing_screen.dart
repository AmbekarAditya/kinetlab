import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';
import '../utils/sun_algorithm.dart';
import '../widgets/glass_card.dart';
import '../widgets/header_bar.dart';
import '../widgets/skin_conditions_grid.dart';
import '../widgets/skin_stress_meter.dart';
import '../widgets/uv_badge.dart';

class LandingScreen extends ConsumerStatefulWidget {
  const LandingScreen({super.key});

  @override
  ConsumerState<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends ConsumerState<LandingScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _handleSunscreenApplication() {
    _confettiController.play();
    ref.read(appProvider.notifier).applySunscreen();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appProvider);
    final notifier = ref.read(appProvider.notifier);
    final weather = state.weather;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Bar
                const HeaderBar(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      // Top Banner: "☀️ Stay Protected"
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '☀️ Stay Protected',
                                  style: GoogleFonts.outfit(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.deepNavy,
                                  ),
                                ),
                                Text(
                                  getSpfAdvice(weather.uvi),
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFFF6B9A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          UvBadge(uvi: weather.uvi),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // "Today's Sun Score" Hero Module
                      GlassCard(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Today's Sun Score",
                                    style: GoogleFonts.outfit(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.deepNavy,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF6B9A).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    '${state.calculatedIntervalMinutes} MIN TIMER',
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      color: const Color(0xFFFF6B9A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          '${weather.tempCelsius.round()}°C',
                                          style: GoogleFonts.outfit(
                                            fontSize: 36,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.deepNavy,
                                            height: 1.0,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Feels ${weather.feelsLikeCelsius.round()}°C',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: AppTheme.deepNavy.withOpacity(0.65),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 38,
                                  width: 1.5,
                                  color: Colors.black.withOpacity(0.08),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          '${weather.humidityPercent.toInt()}%',
                                          style: GoogleFonts.outfit(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.deepNavy,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Humidity',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: AppTheme.deepNavy.withOpacity(0.65),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 38,
                                  width: 1.5,
                                  color: Colors.black.withOpacity(0.08),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'UV ${weather.uvi.toStringAsFixed(1)}',
                                          style: GoogleFonts.outfit(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.deepNavy,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Peak UVI',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: AppTheme.deepNavy.withOpacity(0.65),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // "Skin Stress" Meter
                      SkinStressMeter(
                        uvi: weather.uvi,
                        tempCelsius: weather.tempCelsius,
                        humidityPercent: weather.humidityPercent,
                        isOutdoor: state.isOutdoor,
                        isHighSweatRisk: state.isHighSweatRisk,
                      ),
                      const SizedBox(height: 16),

                      // Segmented Toggles: Indoor vs Outdoor & Sweat Risk
                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '⚙️ Athlete Activity Settings',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.deepNavy,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSegmentedOption(
                                    icon: '🏠',
                                    label: 'Indoor',
                                    isSelected: !state.isOutdoor,
                                    onTap: () => notifier.toggleOutdoor(false),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildSegmentedOption(
                                    icon: '🌞',
                                    label: 'Outdoor',
                                    isSelected: state.isOutdoor,
                                    onTap: () => notifier.toggleOutdoor(true),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSegmentedOption(
                                    icon: '🚶‍♂️',
                                    label: 'Light Activity',
                                    isSelected: !state.isHighSweatRisk,
                                    onTap: () =>
                                        notifier.toggleHighSweatRisk(false),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildSegmentedOption(
                                    icon: '🔥',
                                    label: 'High Sweat / Sport',
                                    isSelected: state.isHighSweatRisk,
                                    onTap: () =>
                                        notifier.toggleHighSweatRisk(true),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 2-Column Grid Cards
                      SkinConditionsGrid(
                        weather: weather,
                        isHighSweatRisk: state.isHighSweatRisk,
                      ),
                      const SizedBox(height: 28),

                      // Massive Action CTA Button: "🧴 I APPLIED SUNSCREEN"
                      GestureDetector(
                        onTap: _handleSunscreenApplication,
                        child: Container(
                          width: double.infinity,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: AppTheme.actionCtaGradient,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: AppTheme.ctaGlowShadow,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('🧴', style: TextStyle(fontSize: 26)),
                                const SizedBox(width: 10),
                                Text(
                                  'I APPLIED SUNSCREEN',
                                  style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Confetti Burst Overlay Widget
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [
            Color(0xFFFF6B9A),
            Color(0xFFFFD166),
            Color(0xFF6C63FF),
            Color(0xFF4ADE80),
          ],
        ),
      ],
    );
  }

  Widget _buildSegmentedOption({
    required String icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6C63FF).withOpacity(0.18)
              : Colors.black.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6C63FF)
                : Colors.black.withOpacity(0.05),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF6C63FF)
                      : AppTheme.deepNavy.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
