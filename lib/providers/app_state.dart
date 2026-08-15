import '../models/weather_model.dart';
import '../utils/sun_algorithm.dart';

class AppState {
  final WeatherData weather;
  final bool isOutdoor;
  final bool isHighSweatRisk;
  final bool isTimerActive;
  final DateTime? applicationTime;
  final DateTime? targetTime;
  final int totalTimerSeconds;
  final int remainingSeconds;
  final int calculatedIntervalMinutes;
  final bool isLoadingLocation;

  const AppState({
    required this.weather,
    required this.isOutdoor,
    required this.isHighSweatRisk,
    required this.isTimerActive,
    this.applicationTime,
    this.targetTime,
    required this.totalTimerSeconds,
    required this.remainingSeconds,
    required this.calculatedIntervalMinutes,
    required this.isLoadingLocation,
  });

  factory AppState.initial() {
    final mock = WeatherData.mockMumbai();
    final interval = calculateReapplicationTimeInMinutes(
      uvi: mock.uvi,
      tempCelsius: mock.tempCelsius,
      humidityPercent: mock.humidityPercent,
      isOutdoor: true,
      isRaining: mock.isRaining,
      isHighSweatRisk: true,
    );

    return AppState(
      weather: mock,
      isOutdoor: true,
      isHighSweatRisk: true,
      isTimerActive: false,
      applicationTime: null,
      targetTime: null,
      totalTimerSeconds: interval * 60,
      remainingSeconds: interval * 60,
      calculatedIntervalMinutes: interval,
      isLoadingLocation: false,
    );
  }

  AppState copyWith({
    WeatherData? weather,
    bool? isOutdoor,
    bool? isHighSweatRisk,
    bool? isTimerActive,
    DateTime? applicationTime,
    DateTime? targetTime,
    int? totalTimerSeconds,
    int? remainingSeconds,
    int? calculatedIntervalMinutes,
    bool? isLoadingLocation,
  }) {
    return AppState(
      weather: weather ?? this.weather,
      isOutdoor: isOutdoor ?? this.isOutdoor,
      isHighSweatRisk: isHighSweatRisk ?? this.isHighSweatRisk,
      isTimerActive: isTimerActive ?? this.isTimerActive,
      applicationTime: applicationTime ?? this.applicationTime,
      targetTime: targetTime ?? this.targetTime,
      totalTimerSeconds: totalTimerSeconds ?? this.totalTimerSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      calculatedIntervalMinutes:
          calculatedIntervalMinutes ?? this.calculatedIntervalMinutes,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
    );
  }
}
