import 'package:dynamische_materialdatenbank/units.dart';
import 'package:flutter_test/flutter_test.dart';

final delta = 0.01;

void main() {
  group('time conversion', () {
    test('base unit', () {
      expect(UnitTypes.time.convert(1), 1);
      expect(UnitTypes.time.convert(1, toUnit: 's'), 1);
      expect(UnitTypes.time.convert(1, fromUnit: 's', toUnit: 's'), 1);
    });
    test('conversion to ms', () {
      expect(UnitTypes.time.convert(1, toUnit: 'ms'), 1000);
      expect(UnitTypes.time.convert(1, fromUnit: 's', toUnit: 'ms'), 1000);
    });
    test('conversion from min', () {
      expect(UnitTypes.time.convert(1, fromUnit: 'min'), 60);
      expect(UnitTypes.time.convert(1, fromUnit: 'min', toUnit: 's'), 60);
    });
  });

  group('temperature conversion', () {
    test('conversion to °C', () {
      expect(
        UnitTypes.temperature.convert(0, fromUnit: 'K', toUnit: '°C'),
        closeTo(-273.15, delta),
      );
    });
    test('conversion from °C', () {
      expect(
        UnitTypes.temperature.convert(0, fromUnit: '°C', toUnit: 'K'),
        closeTo(273.15, delta),
      );
    });
    test('conversion to °F', () {
      expect(
        UnitTypes.temperature.convert(0, fromUnit: 'K', toUnit: '°F'),
        closeTo(-459.67, delta),
      );
    });
    test('conversion from °F', () {
      expect(
        UnitTypes.temperature.convert(0, fromUnit: '°F', toUnit: 'K'),
        closeTo(255.3722, delta),
      );
    });
  });

  group('w-value conversion', () {
    test('base unit', () {
      expect(UnitTypes.wValue.convert(1, toUnit: 'kg/m²√h'), closeTo(1, delta));
    });
    test('conversion to kg/m²√s', () {
      expect(
        UnitTypes.wValue.convert(1, fromUnit: 'kg/m²√h', toUnit: 'kg/m²√s'),
        closeTo(1 / 60, delta),
      );
    });
    test('conversion from kg/m²√d', () {
      expect(
        UnitTypes.wValue.convert(1, fromUnit: 'kg/m²√d', toUnit: 'kg/m²√h'),
        closeTo(0.2, delta),
      );
    });
  });
}
