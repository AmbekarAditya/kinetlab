import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/weather_model.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class SkinConditionsGrid extends StatelessWidget {
  final WeatherData weather;
  final bool isHighSweatRisk;

  const SkinConditionsGrid({
    super.key,
    required this.weather,
    required this.isHighSweatRisk,
  });

  Widget _buildMetricCard({
    required String emoji,
    required String label,
    required String value,
    required String subtext,
    required Color accentColor,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.deepNavy.withOpacity(0.65),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.deepNavy,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtext,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppTheme.deepNavy.withOpacity(0.55),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            '📊 Environmental Telemetry',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.deepNavy,
            ),
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _buildMetricCard(
              emoji: '☀️',
              label: 'UV Index',
              value: 'UV ${weather.uvi.toStringAsFixed(1)}',
              subtext: weather.uvi >= 8.0
                  ? 'Extreme Burn Risk'
                  : (weather.uvi >= 5.0 ? 'High Intensity' : 'Moderate Sun'),
              accentColor: weather.uvi >= 8.0
                  ? AppTheme.statusDanger
                  : AppTheme.statusWarning,
            ),
            _buildMetricCard(
              emoji: '💧',
              label: 'Humidity',
              value: '${weather.humidityPercent.toInt()}%',
              subtext: weather.humidityPercent > 75
                  ? 'Sweat Degradation High'
                  : 'Normal Evaporation',
              accentColor: const Color(0xFF3B82F6),
            ),
            _buildMetricCard(
              emoji: '🌡️',
              label: 'Temperature',
              value: '${weather.tempCelsius.round()}°C',
              subtext: 'Feels like ${weather.feelsLikeCelsius.round()}°C',
              accentColor: const Color(0xFFF97316),
            ),
            _buildMetricCard(
              emoji: '💨',
              label: 'Wind Speed',
              value: '${weather.windSpeedKmH.round()} km/h',
              subtext: 'Breeze Factor',
              accentColor: const Color(0xFF14B8A6),
            ),
            _buildMetricCard(
              emoji: '☁️',
              label: 'Cloud Cover',
              value: '${weather.cloudCoverPercent.round()}%',
              subtext: weather.cloudCoverPercent > 60
                  ? 'Cloud Filtered UV'
                  : 'Direct Rays',
              accentColor: const Color(0xFF8B5CF6),
            ),
            _buildMetricCard(
              emoji: '💦',
              label: 'Sweat Risk',
              value: isHighSweatRisk ? 'High Risk 🔥' : 'Standard 🚶‍♂️',
              subtext: isHighSweatRisk
                  ? '-20m Washout Offset'
                  : 'Normal Barrier',
              accentColor: isHighSweatRisk
                  ? AppTheme.statusDanger
                  : AppTheme.statusSuccess,
            ),
          ],
        ),
      ],
    );
  }
}
