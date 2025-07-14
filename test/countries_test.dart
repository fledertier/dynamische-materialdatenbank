import 'package:dynamische_materialdatenbank/material/attribute/custom/origin_country/country.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('country from iso', () {
    expect(Country.fromCode('SE').name, 'Sweden');
  });
}
