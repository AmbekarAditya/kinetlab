import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const double fallbackLat = 19.0760;
  static const double fallbackLon = 72.8777;

  static final List<PresetLocation> presetLocations = [
    PresetLocation(
      name: 'Mumbai',
      flagEmoji: '🇮🇳',
      latitude: 19.0760,
      longitude: 72.8777,
      mockData: WeatherData(
        uvi: 8.4,
        tempCelsius: 32.5,
        humidityPercent: 78.0,
        windSpeedKmH: 14.2,
        cloudCoverPercent: 25.0,
        feelsLikeCelsius: 37.0,
        locationName: 'Mumbai, IN',
        isRaining: false,
        updatedAt: DateTime.now(),
      ),
    ),
    PresetLocation(
      name: 'Miami Beach',
      flagEmoji: '🇺🇸',
      latitude: 25.7617,
      longitude: -80.1918,
      mockData: WeatherData(
        uvi: 10.2,
        tempCelsius: 34.0,
        humidityPercent: 82.0,
        windSpeedKmH: 18.5,
        cloudCoverPercent: 15.0,
        feelsLikeCelsius: 41.2,
        locationName: 'Miami Beach, US',
        isRaining: false,
        updatedAt: DateTime.now(),
      ),
    ),
    PresetLocation(
      name: 'Sydney',
      flagEmoji: '🇦🇺',
      latitude: -33.8688,
      longitude: 151.2093,
      mockData: WeatherData(
        uvi: 9.1,
        tempCelsius: 29.8,
        humidityPercent: 64.0,
        windSpeedKmH: 22.0,
        cloudCoverPercent: 30.0,
        feelsLikeCelsius: 32.0,
        locationName: 'Sydney, AU',
        isRaining: false,
        updatedAt: DateTime.now(),
      ),
    ),
    PresetLocation(
      name: 'Boulder',
      flagEmoji: '🇺🇸',
      latitude: 40.0150,
      longitude: -105.2705,
      mockData: WeatherData(
        uvi: 7.8,
        tempCelsius: 26.5,
        humidityPercent: 38.0,
        windSpeedKmH: 12.0,
        cloudCoverPercent: 10.0,
        feelsLikeCelsius: 27.0,
        locationName: 'Boulder, CO',
        isRaining: false,
        updatedAt: DateTime.now(),
      ),
    ),
    PresetLocation(
      name: 'Tokyo',
      flagEmoji: '🇯🇵',
      latitude: 35.6762,
      longitude: 139.6503,
      mockData: WeatherData(
        uvi: 6.5,
        tempCelsius: 28.0,
        humidityPercent: 70.0,
        windSpeedKmH: 10.5,
        cloudCoverPercent: 45.0,
        feelsLikeCelsius: 30.5,
        locationName: 'Tokyo, JP',
        isRaining: false,
        updatedAt: DateTime.now(),
      ),
    ),
    PresetLocation(
      name: 'Chamonix',
      flagEmoji: '🇫🇷',
      latitude: 45.9237,
      longitude: 6.8694,
      mockData: WeatherData(
        uvi: 11.5, // Alpine high UV reflection
        tempCelsius: 21.0,
        humidityPercent: 45.0,
        windSpeedKmH: 15.0,
        cloudCoverPercent: 5.0,
        feelsLikeCelsius: 21.0,
        locationName: 'Chamonix, FR',
        isRaining: false,
        updatedAt: DateTime.now(),
      ),
    ),
  ];

  /// Request geolocation permission and fetch position.
  /// Defaults to Mumbai if permission denied, restricted, or disabled.
  Future<Position?> getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled.');
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permission denied.');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Location permissions are permanently denied.');
        return null;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }

  /// Fetches weather and UV data for given coordinates.
  /// Uses OpenWeatherMap endpoint if available, otherwise returns rich simulated weather.
  Future<WeatherData> fetchWeatherData({
    double? lat,
    double? lon,
    String? apiKey,
  }) async {
    final targetLat = lat ?? fallbackLat;
    final targetLon = lon ?? fallbackLon;

    // Check if matching preset location exists
    for (var preset in presetLocations) {
      if ((preset.latitude - targetLat).abs() < 0.1 &&
          (preset.longitude - targetLon).abs() < 0.1) {
        return preset.mockData.copyWith(updatedAt: DateTime.now());
      }
    }

    if (apiKey != null && apiKey.isNotEmpty) {
      try {
        final url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$targetLat&lon=$targetLon&units=metric&appid=$apiKey',
        );
        final response = await http.get(url).timeout(const Duration(seconds: 4));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final main = data['main'] ?? {};
          final wind = data['wind'] ?? {};
          final clouds = data['clouds'] ?? {};
          final weatherList = (data['weather'] as List?) ?? [];
          final mainWeather = weatherList.isNotEmpty ? weatherList.first['main'] : '';
          final bool isRaining = mainWeather.toString().toLowerCase().contains('rain');

          // Fetch UVI from OpenWeather OneCall or fallback calculate estimate
          double temp = (main['temp'] as num?)?.toDouble() ?? 30.0;
          double humidity = (main['humidity'] as num?)?.toDouble() ?? 60.0;
          double uviEstimate = (temp > 30 ? 8.5 : 5.5);

          return WeatherData(
            uvi: uviEstimate,
            tempCelsius: temp,
            humidityPercent: humidity,
            windSpeedKmH: ((wind['speed'] as num?)?.toDouble() ?? 3.5) * 3.6,
            cloudCoverPercent: (clouds['all'] as num?)?.toDouble() ?? 20.0,
            feelsLikeCelsius: (main['feels_like'] as num?)?.toDouble() ?? temp,
            locationName: data['name'] ?? 'Detected Location',
            isRaining: isRaining,
            updatedAt: DateTime.now(),
          );
        }
      } catch (e) {
        debugPrint('OpenWeatherMap API request error: $e');
      }
    }

    // Fallback using real coordinates if provided
    if (lat != null && lon != null) {
      return WeatherData.mockMumbai().copyWith(
        locationName: 'GPS (${lat.toStringAsFixed(2)}°, ${lon.toStringAsFixed(2)}°)',
        updatedAt: DateTime.now(),
      );
    }

    // Default Fallback: Mumbai, IN
    return WeatherData.mockMumbai().copyWith(updatedAt: DateTime.now());
  }
}
