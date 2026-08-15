class WeatherData {
  final double uvi;
  final double tempCelsius;
  final double humidityPercent;
  final double windSpeedKmH;
  final double cloudCoverPercent;
  final double feelsLikeCelsius;
  final String locationName;
  final bool isRaining;
  final DateTime updatedAt;

  // Reverse Geocoding & GPS Location Fields
  final double latitude;
  final double longitude;
  final String? area;
  final String? city;
  final String? stateName;
  final String? country;
  final String? coordinates;

  const WeatherData({
    required this.uvi,
    required this.tempCelsius,
    required this.humidityPercent,
    required this.windSpeedKmH,
    required this.cloudCoverPercent,
    required this.feelsLikeCelsius,
    required this.locationName,
    required this.isRaining,
    required this.updatedAt,
    this.latitude = 19.0760,
    this.longitude = 72.8777,
    this.area,
    this.city,
    this.stateName,
    this.country,
    this.coordinates,
  });

  /// Location Title Text: [area, city, stateName, country].where((e) => e != null && e.isNotEmpty).join(', ')
  String get fullLocationTitle {
    final list = [area, city, stateName, country];
    final validParts = list.where((e) => e != null && e.isNotEmpty).toList();
    if (validParts.isNotEmpty) {
      return validParts.join(', ');
    }
    return locationName;
  }

  /// Location Coordinates Subtitle Text: '📍 Lat: ${latitude.toStringAsFixed(4)}, Long: ${longitude.toStringAsFixed(4)}'
  String get formattedCoordinatesSubtitle {
    return '📍 Lat: ${latitude.toStringAsFixed(4)}, Long: ${longitude.toStringAsFixed(4)}';
  }

  factory WeatherData.mockMumbai() {
    return WeatherData(
      uvi: 8.4,
      tempCelsius: 32.5,
      humidityPercent: 78.0,
      windSpeedKmH: 14.2,
      cloudCoverPercent: 25.0,
      feelsLikeCelsius: 37.0,
      locationName: 'Mumbai, IN',
      isRaining: false,
      updatedAt: DateTime.now(),
      latitude: 19.0760,
      longitude: 72.8777,
      area: 'Mumbai Beach',
      city: 'Mumbai',
      stateName: 'Maharashtra',
      country: 'India',
      coordinates: '19.0760, 72.8777',
    );
  }

  WeatherData copyWith({
    double? uvi,
    double? tempCelsius,
    double? humidityPercent,
    double? windSpeedKmH,
    double? cloudCoverPercent,
    double? feelsLikeCelsius,
    String? locationName,
    bool? isRaining,
    DateTime? updatedAt,
    double? latitude,
    double? longitude,
    String? area,
    String? city,
    String? stateName,
    String? country,
    String? coordinates,
  }) {
    return WeatherData(
      uvi: uvi ?? this.uvi,
      tempCelsius: tempCelsius ?? this.tempCelsius,
      humidityPercent: humidityPercent ?? this.humidityPercent,
      windSpeedKmH: windSpeedKmH ?? this.windSpeedKmH,
      cloudCoverPercent: cloudCoverPercent ?? this.cloudCoverPercent,
      feelsLikeCelsius: feelsLikeCelsius ?? this.feelsLikeCelsius,
      locationName: locationName ?? this.locationName,
      isRaining: isRaining ?? this.isRaining,
      updatedAt: updatedAt ?? this.updatedAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      area: area ?? this.area,
      city: city ?? this.city,
      stateName: stateName ?? this.stateName,
      country: country ?? this.country,
      coordinates: coordinates ?? this.coordinates,
    );
  }
}

class PresetLocation {
  final String name;
  final String flagEmoji;
  final double latitude;
  final double longitude;
  final WeatherData mockData;

  const PresetLocation({
    required this.name,
    required this.flagEmoji,
    required this.latitude,
    required this.longitude,
    required this.mockData,
  });
}
