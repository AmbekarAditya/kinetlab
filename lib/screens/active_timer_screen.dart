import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/countdown_ring.dart';
import '../widgets/glass_card.dart';
import '../widgets/header_bar.dart';

class ActiveTimerScreen extends ConsumerStatefulWidget {
  const ActiveTimerScreen({super.key});

  @override
  ConsumerState<ActiveTimerScreen> createState() => _ActiveTimerScreenState();
}

class _ActiveTimerScreenState extends ConsumerState<ActiveTimerScreen> {
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

  void _handleReapplyEarly() {
    _confettiController.play();
    ref.read(appProvider.notifier).reapplyEarly();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appProvider);
    final notifier = ref.read(appProvider.notifier);
    final weather = state.weather;

    final String appliedTimeStr = state.applicationTime != null
        ? DateFormat('h:mm a').format(state.applicationTime!)
        : '--:--';

    final String targetTimeStr = state.targetTime != null
        ? DateFormat('h:mm a').format(state.targetTime!)
        : '--:--';

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              children: [
                // Header Bar
                const HeaderBar(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      // Status Header Banner: "🧴 Protected!"
                      GlassCard(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    color: AppTheme.statusSuccess,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '🧴 Protected!',
                                      style: GoogleFonts.outfit(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.deepNavy,
                                      ),
                                    ),
                                    Text(
                                      'Target Reapplication: $targetTimeStr',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme.deepNavy.withOpacity(0.65),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppTheme.statusSuccess.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                '${state.calculatedIntervalMinutes}m Window',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF15803D),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Massive Animated Circular Countdown Timer
                      GlassCard(
                        padding: const EdgeInsets.symmetric(
                            vertical: 28, horizontal: 20),
                        child: Column(
                          children: [
                            CountdownRing(
                              totalSeconds: state.totalTimerSeconds,
                              remainingSeconds: state.remainingSeconds,
                              statusText: 'UV Barrier Active 🛡️',
                              appliedTimeText: 'Applied at $appliedTimeStr',
                            ),
                            const SizedBox(height: 20),

                            // Quick Adjust +/- 15m buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildAdjustButton(
                                  label: '-15m',
                                  onTap: () => notifier.adjustTimer(-15),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Adjust Timer',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.deepNavy.withOpacity(0.6),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                _buildAdjustButton(
                                  label: '+15m',
                                  onTap: () => notifier.adjustTimer(15),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Live Dynamic Activity & Environment Toggles
                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '⚡ Dynamic Environment Tuning',
                                  style: GoogleFonts.outfit(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.deepNavy,
                                  ),
                                ),
                                Text(
                                  'Live Scaling',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: const Color(0xFFFF6B9A),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMiniToggle(
                                    icon: '🏠',
                                    label: 'Indoor (+40m)',
                                    isSelected: !state.isOutdoor,
                                    onTap: () => notifier.toggleOutdoor(false),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildMiniToggle(
                                    icon: '🌞',
                                    label: 'Outdoor',
                                    isSelected: state.isOutdoor,
                                    onTap: () => notifier.toggleOutdoor(true),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMiniToggle(
                                    icon: '🚶‍♂️',
                                    label: 'Light Work',
                                    isSelected: !state.isHighSweatRisk,
                                    onTap: () =>
                                        notifier.toggleHighSweatRisk(false),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildMiniToggle(
                                    icon: '🔥',
                                    label: 'High Sweat (-20m)',
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

                      // Persistent Environmental Telemetry Footer
                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildTelemetryItem(
                              emoji: '☀️',
                              label: 'UV Index',
                              value: 'UV ${weather.uvi.toStringAsFixed(1)}',
                            ),
                            Container(
                              height: 30,
                              width: 1,
                              color: Colors.black.withOpacity(0.08),
                            ),
                            _buildTelemetryItem(
                              emoji: '🌡️',
                              label: 'Temperature',
                              value: '${weather.tempCelsius.round()}°C',
                            ),
                            Container(
                              height: 30,
                              width: 1,
                              color: Colors.black.withOpacity(0.08),
                            ),
                            _buildTelemetryItem(
                              emoji: '💧',
                              label: 'Humidity',
                              value: '${weather.humidityPercent.toInt()}%',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Action Buttons: "Reapply Early" & "Reset Timer"
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => notifier.resetTimer(),
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppTheme.deepNavy.withOpacity(0.15),
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '⏹️ Reset Timer',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.deepNavy,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: GestureDetector(
                              onTap: _handleReapplyEarly,
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: AppTheme.actionCtaGradient,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: AppTheme.ctaGlowShadow,
                                ),
                                child: Center(
                                  child: Text(
                                    '🧴 Reapply Early',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildAdjustButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.1)),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.deepNavy,
          ),
        ),
      ),
    );
  }

  Widget _buildMiniToggle({
    required String icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6C63FF).withOpacity(0.18)
              : Colors.black.withOpacity(0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6C63FF)
                : Colors.black.withOpacity(0.05),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 13)),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF6C63FF)
                    : AppTheme.deepNavy.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTelemetryItem({
    required String emoji,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppTheme.deepNavy.withOpacity(0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppTheme.deepNavy,
          ),
        ),
      ],
    );
  }
}
