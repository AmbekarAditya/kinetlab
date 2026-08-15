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
  });

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
