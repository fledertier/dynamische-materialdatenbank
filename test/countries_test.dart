import 'package:dynamische_materialdatenbank/material/attribute/custom/origin_country/countries.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('country from iso', () {
    expect(Country.fromIso('SE').name, 'Sweden');
  });
}
