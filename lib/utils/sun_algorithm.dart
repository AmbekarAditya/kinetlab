/// Dynamic calculation engine for kinet sunscreen reapplication timer.
/// Designed specifically for athletes and active individuals.

int calculateReapplicationTimeInMinutes({
  required double uvi,
  required double tempCelsius,
  required double humidityPercent,
  required bool isOutdoor,
  required bool isRaining,
  required bool isHighSweatRisk,
}) {
  int time = 120; // Base: 2 hours

  // UV Modifier
  if (uvi >= 11) {
    time -= 40;
  } else if (uvi >= 8) {
    time -= 30;
  } else if (uvi >= 6) {
    time -= 20;
  } else if (uvi >= 3) {
    time -= 10;
  }

  // Environment Modifier
  if (!isOutdoor) time += 40;
  if (humidityPercent > 80) time -= 15;
  if (tempCelsius >= 40) {
    time -= 25;
  } else if (tempCelsius >= 35) {
    time -= 15;
  }
  if (isHighSweatRisk) time -= 20;
  if (isRaining) time -= 15;

  // Floor safeguard
  return time.clamp(30, 180);
}

/// Calculates Skin Stress Score (0 - 100%) based on environmental stress factors:
/// UV Index (weighted 50%), Temperature (weighted 30%), Humidity (weighted 20%).
double calculateSkinStressScore({
  required double uvi,
  required double tempCelsius,
  required double humidityPercent,
  required bool isOutdoor,
  required bool isHighSweatRisk,
}) {
  if (!isOutdoor) return 15.0; // Minimal stress indoors

  double uvComponent = (uvi / 12.0) * 50.0;
  double tempComponent = ((tempCelsius.clamp(15.0, 45.0) - 15.0) / 30.0) * 30.0;
  double humidityComponent = (humidityPercent / 100.0) * 20.0;

  double score = uvComponent + tempComponent + humidityComponent;
  if (isHighSweatRisk) score += 10.0;

  return score.clamp(0.0, 100.0);
}

/// Returns a human-readable summary of UV risk category.
String getUvCategory(double uvi) {
  if (uvi >= 11.0) return 'Extreme Risk ⚡';
  if (uvi >= 8.0) return 'Very High 🔴';
  if (uvi >= 6.0) return 'High Risk 🟧';
  if (uvi >= 3.0) return 'Moderate 🟨';
  return 'Low Risk 🟢';
}

/// Returns recommended athlete SPF advice based on UVI.
String getSpfAdvice(double uvi) {
  if (uvi >= 8.0) return 'SPF 50+ Broad Spectrum Water Resistant';
  if (uvi >= 5.0) return 'SPF 30-50+ Sweat Proof';
  return 'SPF 30+ Daily Sport Sunscreen';
}
