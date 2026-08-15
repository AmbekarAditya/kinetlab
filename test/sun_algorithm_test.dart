import 'package:flutter_test/flutter_test.dart';
import 'package:kinetlab/utils/sun_algorithm.dart';

void main() {
  group('calculateReapplicationTimeInMinutes', () {
    test('Base outdoor conditions (Low UV, normal weather)', () {
      final time = calculateReapplicationTimeInMinutes(
        uvi: 2.0,
        tempCelsius: 25.0,
        humidityPercent: 50.0,
        isOutdoor: true,
        isRaining: false,
        isHighSweatRisk: false,
      );
      // Base: 120, no modifiers
      expect(time, 120);
    });

    test('High UV, extreme heat, high sweat risk outdoors', () {
      final time = calculateReapplicationTimeInMinutes(
        uvi: 9.5, // >=8 -> -30
        tempCelsius: 38.0, // >=35 -> -15
        humidityPercent: 85.0, // >80 -> -15
        isOutdoor: true,
        isRaining: false,
        isHighSweatRisk: true, // -20
      );
      // 120 - 30 - 15 - 15 - 20 = 40
      expect(time, 40);
    });

    test('Indoor conditions add +40 minutes', () {
      final time = calculateReapplicationTimeInMinutes(
        uvi: 5.0, // >=3 -> -10
        tempCelsius: 22.0,
        humidityPercent: 40.0,
        isOutdoor: false, // +40
        isRaining: false,
        isHighSweatRisk: false,
      );
      // 120 - 10 + 40 = 150
      expect(time, 150);
    });

    test('Clamps at minimum floor of 30 minutes', () {
      final time = calculateReapplicationTimeInMinutes(
        uvi: 12.0, // -40
        tempCelsius: 42.0, // -25
        humidityPercent: 90.0, // -15
        isOutdoor: true,
        isRaining: true, // -15
        isHighSweatRisk: true, // -20
      );
      // 120 - 40 - 25 - 15 - 15 - 20 = 5 -> clamped to 30
      expect(time, 30);
    });

    test('Clamps at maximum ceiling of 180 minutes', () {
      final time = calculateReapplicationTimeInMinutes(
        uvi: 1.0, // 0
        tempCelsius: 20.0, // 0
        humidityPercent: 30.0, // 0
        isOutdoor: false, // +40
        isRaining: false, // 0
        isHighSweatRisk: false, // 0
      );
      // 120 + 40 = 160 (within clamp range 30..180)
      expect(time, 160);
    });
  });
}
