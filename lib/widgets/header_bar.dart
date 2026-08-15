import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_providers.dart';
import '../services/weather_service.dart';

class HeaderBar extends ConsumerWidget {
  const HeaderBar({super.key});

  void _showLocationPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '📍 Training Locations',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Select a location or auto-detect via GPS:',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.my_location, color: Color(0xFF6C63FF)),
                ),
                title: Text(
                  'Auto-Detect Current GPS Location',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                subtitle: const Text('Uses real-time device coordinates'),
                onTap: () {
                  Navigator.pop(context);
                  ref.read(appProvider.notifier).refreshLocation();
                },
              ),
              const Divider(height: 24),
              ...WeatherService.presetLocations.map(
                (preset) => ListTile(
                  leading: Text(
                    preset.flagEmoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    preset.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    'UV ${preset.mockData.uvi} • ${preset.mockData.tempCelsius.toStringAsFixed(1)}°C • ${preset.mockData.humidityPercent.toInt()}% Hum',
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () {
                    ref.read(appProvider.notifier).selectPresetLocation(preset);
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Brand Logo & Tagline
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'kinet',
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF1F2937),
                        letterSpacing: -1.2,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF6B9A),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                Text(
                  'by athletes, for athletes',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF1F2937).withOpacity(0.75),
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Location Selector Chip
          Flexible(
            fit: FlexFit.loose,
            child: GestureDetector(
              onTap: () => _showLocationPicker(context, ref),
              child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.6),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  state.isLoadingLocation
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFFF6B9A),
                          ),
                        )
                      : const Text(
                          '📍',
                          style: TextStyle(fontSize: 14),
                        ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          [
                            state.weather.area,
                            state.weather.city,
                            state.weather.stateName,
                            state.weather.country,
                          ]
                              .where((e) => e != null && e.isNotEmpty)
                              .join(', '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        Text(
                          '📍 Lat: ${state.weather.latitude.toStringAsFixed(4)}, Long: ${state.weather.longitude.toStringAsFixed(4)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1F2937).withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: Color(0xFF1F2937),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      ),
    );
  }
}
