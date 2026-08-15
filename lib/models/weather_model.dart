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

  // Reverse Geocoding Location Fields
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
    this.area,
    this.city,
    this.stateName,
    this.country,
    this.coordinates,
  });

  /// Formatted Primary Title: Area, City
  String get primaryLocationTitle {
    final parts = <String>[];
    if (area != null && area!.isNotEmpty) parts.add(area!);
    if (city != null && city!.isNotEmpty && city != area) parts.add(city!);

    if (parts.isNotEmpty) {
      return parts.join(', ');
    }
    return locationName;
  }

  /// Formatted Subtitle: State, Country • (Lat: XX.XXXX, Long: YY.YYYY)
  String? get secondaryLocationSubtitle {
    final locationParts = <String>[];
    if (stateName != null && stateName!.isNotEmpty) locationParts.add(stateName!);
    if (country != null && country!.isNotEmpty) locationParts.add(country!);

    String locationStr = locationParts.join(', ');
    if (coordinates != null && coordinates!.isNotEmpty) {
      if (locationStr.isNotEmpty) {
        return '$locationStr • ($coordinates)';
      }
      return '($coordinates)';
    }
    return locationStr.isNotEmpty ? locationStr : null;
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
      area: 'Bandra',
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
