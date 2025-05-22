import 'package:dynamische_materialdatenbank/material/attribute/default/country/country.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('country from iso', () {
    expect(Country.fromCode('SE').name, 'Sweden');
  });
}
