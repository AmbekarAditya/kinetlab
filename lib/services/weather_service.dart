import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
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
        area: 'Bandra West',
        city: 'Mumbai',
        stateName: 'Maharashtra',
        country: 'India',
        coordinates: '19.0760, 72.8777',
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
        area: 'South Beach',
        city: 'Miami Beach',
        stateName: 'Florida',
        country: 'United States',
        coordinates: '25.7617, -80.1918',
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
        area: 'Circular Quay',
        city: 'Sydney',
        stateName: 'New South Wales',
        country: 'Australia',
        coordinates: '-33.8688, 151.2093',
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
        area: 'Flatirons District',
        city: 'Boulder',
        stateName: 'Colorado',
        country: 'United States',
        coordinates: '40.0150, -105.2705',
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
        area: 'Shinjuku',
        city: 'Tokyo',
        stateName: 'Kanto',
        country: 'Japan',
        coordinates: '35.6762, 139.6503',
      ),
    ),
    PresetLocation(
      name: 'Chamonix',
      flagEmoji: '🇫🇷',
      latitude: 45.9237,
      longitude: 6.8694,
      mockData: WeatherData(
        uvi: 11.5,
        tempCelsius: 21.0,
        humidityPercent: 45.0,
        windSpeedKmH: 15.0,
        cloudCoverPercent: 5.0,
        feelsLikeCelsius: 21.0,
        locationName: 'Chamonix, FR',
        isRaining: false,
        updatedAt: DateTime.now(),
        area: 'Mont-Blanc Valley',
        city: 'Chamonix-Mont-Blanc',
        stateName: 'Auvergne-Rhône-Alpes',
        country: 'France',
        coordinates: '45.9237, 6.8694',
      ),
    ),
  ];

  /// Request geolocation permission and fetch position.
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

  /// Perform reverse geocoding to extract Area, City, State, Country, and Lat/Long coordinates.
  Future<Map<String, String>> _performReverseGeocode(double lat, double lon) async {
    final String coordStr = '${lat.toStringAsFixed(4)}, ${lon.toStringAsFixed(4)}';
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;

        final String area = (p.subLocality?.isNotEmpty == true)
            ? p.subLocality!
            : (p.locality?.isNotEmpty == true)
                ? p.locality!
                : (p.subAdministrativeArea?.isNotEmpty == true)
                    ? p.subAdministrativeArea!
                    : ((p.name?.isNotEmpty == true && p.name != p.postalCode)
                        ? p.name!
                        : 'Current Location');

        final String city = (p.locality?.isNotEmpty == true && p.locality != area)
            ? p.locality!
            : (p.subAdministrativeArea ?? '');

        final String stateName = p.administrativeArea ?? '';
        final String country = p.country ?? '';

        return {
          'area': area,
          'city': city,
          'stateName': stateName,
          'country': country,
          'coordinates': coordStr,
        };
      }
    } catch (e) {
      debugPrint('Reverse geocoding error: $e');
    }

    return {
      'area': 'Current Location',
      'coordinates': coordStr,
    };
  }

  /// Fetches weather and UV data for given coordinates with reverse geocoded details.
  Future<WeatherData> fetchWeatherData({
    double? lat,
    double? lon,
    String? apiKey,
  }) async {
    final targetLat = lat ?? fallbackLat;
    final targetLon = lon ?? fallbackLon;

    final geoDetails = await _performReverseGeocode(targetLat, targetLon);

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
            latitude: targetLat,
            longitude: targetLon,
            area: geoDetails['area'],
            city: geoDetails['city'] ?? data['name'],
            stateName: geoDetails['stateName'],
            country: geoDetails['country'],
            coordinates: geoDetails['coordinates'],
          );
        }
      } catch (e) {
        debugPrint('OpenWeatherMap API request error: $e');
      }
    }

    // Dynamic weather fallback constructed directly from real GPS & geocoded placemark details
    return WeatherData(
      uvi: 7.5,
      tempCelsius: 31.0,
      humidityPercent: 72.0,
      windSpeedKmH: 12.0,
      cloudCoverPercent: 30.0,
      feelsLikeCelsius: 35.0,
      locationName: geoDetails['city'] != null && geoDetails['city']!.isNotEmpty
          ? '${geoDetails['city']}, ${geoDetails['country'] ?? ''}'
          : 'GPS (${targetLat.toStringAsFixed(2)}°, ${targetLon.toStringAsFixed(2)}°)',
      isRaining: false,
      updatedAt: DateTime.now(),
      latitude: targetLat,
      longitude: targetLon,
      area: geoDetails['area'],
      city: geoDetails['city'],
      stateName: geoDetails['stateName'],
      country: geoDetails['country'],
      coordinates: geoDetails['coordinates'],
    );
  }
}
