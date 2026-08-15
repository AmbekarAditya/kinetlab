import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/weather_model.dart';
import '../services/notification_service.dart';
import '../services/weather_service.dart';
import '../utils/sun_algorithm.dart';
import 'app_state.dart';

class AppNotifier extends StateNotifier<AppState> {
  final WeatherService _weatherService;
  final NotificationService _notificationService;
  Timer? _ticker;

  AppNotifier(this._weatherService, this._notificationService)
      : super(AppState.initial()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoadingLocation: true);
    await _notificationService.init();
    await _notificationService.requestPermissions();

    final position = await _weatherService.getCurrentPosition();
    if (position != null) {
      final weather = await _weatherService.fetchWeatherData(
        lat: position.latitude,
        lon: position.longitude,
      );
      _updateWeatherAndInterval(weather);
    } else {
      // Fallback Mumbai weather
      final weather = await _weatherService.fetchWeatherData();
      _updateWeatherAndInterval(weather);
    }
    state = state.copyWith(isLoadingLocation: false);
  }

  void _updateWeatherAndInterval(WeatherData weather) {
    final interval = calculateReapplicationTimeInMinutes(
      uvi: weather.uvi,
      tempCelsius: weather.tempCelsius,
      humidityPercent: weather.humidityPercent,
      isOutdoor: state.isOutdoor,
      isRaining: weather.isRaining,
      isHighSweatRisk: state.isHighSweatRisk,
    );

    int totalSec = interval * 60;
    int remSec = state.isTimerActive ? state.remainingSeconds : totalSec;

    state = state.copyWith(
      weather: weather,
      calculatedIntervalMinutes: interval,
      totalTimerSeconds: totalSec,
      remainingSeconds: remSec,
    );
  }

  void toggleOutdoor(bool isOutdoor) {
    HapticFeedback.lightImpact();
    state = state.copyWith(isOutdoor: isOutdoor);
    _recalculateInterval();
  }

  void toggleHighSweatRisk(bool isHighSweatRisk) {
    HapticFeedback.lightImpact();
    state = state.copyWith(isHighSweatRisk: isHighSweatRisk);
    _recalculateInterval();
  }

  void _recalculateInterval() {
    final interval = calculateReapplicationTimeInMinutes(
      uvi: state.weather.uvi,
      tempCelsius: state.weather.tempCelsius,
      humidityPercent: state.weather.humidityPercent,
      isOutdoor: state.isOutdoor,
      isRaining: state.weather.isRaining,
      isHighSweatRisk: state.isHighSweatRisk,
    );

    int newTotalSec = interval * 60;
    int newRemSec = state.remainingSeconds;

    if (state.isTimerActive) {
      // Scale remaining time dynamically based on new environment ratio
      double ratio = newTotalSec / (state.totalTimerSeconds > 0 ? state.totalTimerSeconds : newTotalSec);
      newRemSec = (state.remainingSeconds * ratio).round().clamp(0, newTotalSec);
    } else {
      newRemSec = newTotalSec;
    }

    state = state.copyWith(
      calculatedIntervalMinutes: interval,
      totalTimerSeconds: newTotalSec,
      remainingSeconds: newRemSec,
    );
  }

  void selectPresetLocation(PresetLocation location) {
    HapticFeedback.selectionClick();
    _updateWeatherAndInterval(location.mockData);
  }

  Future<void> refreshLocation() async {
    state = state.copyWith(isLoadingLocation: true);
    final position = await _weatherService.getCurrentPosition();
    final weather = await _weatherService.fetchWeatherData(
      lat: position?.latitude,
      lon: position?.longitude,
    );
    _updateWeatherAndInterval(weather);
    state = state.copyWith(isLoadingLocation: false);
  }

  /// Triggers sunscreen application phase transition with haptic feedback & notifications.
  void applySunscreen() {
    HapticFeedback.mediumImpact();
    _ticker?.cancel();

    final now = DateTime.now();
    final interval = calculateReapplicationTimeInMinutes(
      uvi: state.weather.uvi,
      tempCelsius: state.weather.tempCelsius,
      humidityPercent: state.weather.humidityPercent,
      isOutdoor: state.isOutdoor,
      isRaining: state.weather.isRaining,
      isHighSweatRisk: state.isHighSweatRisk,
    );

    final target = now.add(Duration(minutes: interval));
    final totalSec = interval * 60;

    state = state.copyWith(
      isTimerActive: true,
      applicationTime: now,
      targetTime: target,
      calculatedIntervalMinutes: interval,
      totalTimerSeconds: totalSec,
      remainingSeconds: totalSec,
    );

    // Schedule notification alert
    _notificationService.showSunscreenAlert(
      title: '🧴 kinet Sun Protection Activated!',
      body: 'Your sunscreen timer is set for $interval mins. We will remind you to reapply!',
    );

    _startCountdown();
  }

  void _startCountdown() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds <= 1) {
        timer.cancel();
        state = state.copyWith(remainingSeconds: 0);

        HapticFeedback.heavyImpact();
        _notificationService.showSunscreenAlert(
          title: '🚨 Time to Reapply Sunscreen!',
          body: 'Your protection window has ended. Reapply now to stay protected.',
        );
      } else {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      }
    });
  }

  void adjustTimer(int deltaMinutes) {
    HapticFeedback.lightImpact();
    if (!state.isTimerActive) return;

    int newRemainingSec = (state.remainingSeconds + (deltaMinutes * 60)).clamp(0, 180 * 60);
    state = state.copyWith(remainingSeconds: newRemainingSec);
  }

  void reapplyEarly() {
    applySunscreen();
  }

  void resetTimer() {
    HapticFeedback.mediumImpact();
    _ticker?.cancel();
    state = state.copyWith(
      isTimerActive: false,
      applicationTime: null,
      targetTime: null,
      remainingSeconds: state.totalTimerSeconds,
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}

// Riverpod Providers
final weatherServiceProvider = Provider((ref) => WeatherService());
final notificationServiceProvider = Provider((ref) => NotificationService());

final appProvider = StateNotifierProvider<AppNotifier, AppState>((ref) {
  final weatherService = ref.watch(weatherServiceProvider);
  final notificationService = ref.watch(notificationServiceProvider);
  return AppNotifier(weatherService, notificationService);
});
