import 'dart:convert';

import 'package:dynamische_materialdatenbank/utils/collection_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('dings', () {
    final original = {
      'biobased': {
        'type': {'id': 'boolean'},
        'id': 'biobased',
        'required': false,
        'nameEn': 'Biobased',
        'nameDe': 'Biobasiert',
      },
      'density': {
        'required': false,
        'type': {'unitType': 'density', 'id': 'number'},
        'nameDe': 'Dichte',
        'nameEn': 'Density',
        'id': 'density',
      },
      'description': {
        'required': true,
        'id': 'description',
        'nameEn': 'Description',
        'type': {'id': 'text', 'multiline': true},
        'nameDe': 'Beschreibung',
      },
      'light reflection': {
        'required': false,
        'type': {'id': 'number', 'unitType': 'proportion'},
        'nameEn': 'Light reflection',
        'id': 'light reflection',
        'nameDe': 'Lichtreflexion',
      },
      'dingsblubb': {
        'type': {
          'id': 'object',
          'attributes': [
            {
              'id': 'dings',
              'type': {'multiline': false, 'id': 'text'},
              'required': false,
              'nameEn': null,
              'nameDe': 'Dings',
            },
            {
              'nameEn': null,
              'type': {
                'attributes': [
                  {
                    'id': 'boop',
                    'required': false,
                    'type': {'id': 'boolean'},
                    'nameEn': null,
                    'nameDe': 'boop',
                  },
                  {
                    'required': true,
                    'id': 'id',
                    'nameDe': 'Id',
                    'type': {'multiline': false, 'id': 'text'},
                    'nameEn': null,
                  },
                ],
                'id': 'object',
              },
              'required': false,
              'nameDe': 'Blubb',
              'id': 'blubb',
            },
          ],
        },
        'required': false,
        'nameDe': 'Dingsblubb',
        'id': 'dingsblubb',
        'nameEn': null,
      },
      'recyclable': {
        'nameEn': 'Recyclable',
        'type': {'id': 'boolean'},
        'id': 'recyclable',
        'nameDe': 'Recycelbar',
        'required': false,
      },
      'w-value': {
        'type': {'unitType': 'wValue', 'id': 'number'},
        'nameEn': 'W-value',
        'required': false,
        'id': 'w-value',
        'nameDe': 'W-Wert',
      },
      'areal density': {
        'nameEn': 'Areal density',
        'required': false,
        'id': 'areal density',
        'nameDe': 'Flächendichte',
        'type': {'unitType': 'arealDensity', 'id': 'number'},
      },
      'light absorption': {
        'nameDe': 'Lichtabsorption',
        'id': 'light absorption',
        'nameEn': 'Light absorption',
        'type': {'unitType': 'proportion', 'id': 'number'},
        'required': false,
      },
      'dings-1': {
        'nameDe': 'Dings',
        'type': {'unitType': null, 'id': 'number'},
        'id': 'dings-1',
        'nameEn': null,
        'required': false,
      },
      'light transmission': {
        'type': {'unitType': 'proportion', 'id': 'number'},
        'id': 'light transmission',
        'nameEn': 'Light transmission',
        'required': false,
        'nameDe': 'Lichtdurchlässigkeit',
      },
      'name': {
        'nameEn': 'Name',
        'id': 'name',
        'nameDe': 'Name',
        'type': {'multiline': false, 'id': 'text'},
        'required': true,
      },
      'u-value': {
        'required': false,
        'nameDe': 'U-Wert',
        'type': {'unitType': 'uValue', 'id': 'number'},
        'nameEn': 'U-value',
        'id': 'u-value',
      },
      'manufacturer': {
        'id': 'manufacturer',
        'nameDe': 'Hersteller',
        'required': false,
        'type': {
          'id': 'object',
          'attributes': [
            {
              'nameDe': 'Name',
              'required': true,
              'type': {'multiline': false, 'id': 'text'},
              'nameEn': null,
              'id': 'name-1',
            },
            {
              'required': false,
              'nameEn': 'Website',
              'nameDe': 'Webseite',
              'type': {'id': 'url'},
              'id': 'website',
            },
          ],
        },
        'nameEn': 'Manufacturer',
      },
      'composition': {
        'required': false,
        'type': {
          'id': 'list',
          'type': {
            'id': 'object',
            'attributes': [
              {
                'type': {'id': 'text', 'multiline': false},
                'nameDe': 'Kategorie',
                'id': 'category',
                'required': true,
                'nameEn': 'Category',
              },
              {
                'type': {'unitType': 'proportion', 'id': 'number'},
                'id': 'share',
                'required': true,
                'nameEn': 'Share',
                'nameDe': 'Anteil',
              },
            ],
          },
        },
        'id': 'composition',
        'nameEn': 'Composition',
        'nameDe': 'Zusammensetzung',
      },
      'subjective impressions': {
        'required': false,
        'type': {
          'id': 'list',
          'type': {
            'attributes': [
              {
                'nameDe': 'Name (De)',
                'type': {'id': 'text', 'multiline': false},
                'required': true,
                'nameEn': '',
                'id': '-1',
              },
              {
                'nameDe': 'Name (En)',
                'nameEn': null,
                'id': 'name (en)',
                'required': false,
                'type': {'id': 'text', 'multiline': false},
              },
              {
                'nameDe': 'Anzahl',
                'nameEn': 'Count',
                'id': 'count-1',
                'type': {'id': 'number', 'unitType': null},
                'required': true,
              },
            ],
            'id': 'object',
          },
        },
        'nameDe': 'Subjektive Eindrücke',
        'nameEn': 'Subjective impressions',
        'id': 'subjective impressions',
      },
      'biodegradable': {
        'id': 'biodegradable',
        'required': false,
        'nameDe': 'Biologisch abbaubar',
        'nameEn': 'Biodegradable',
        'type': {'id': 'boolean'},
      },
      'origin country': {
        'id': 'origin country',
        'nameDe': 'Herkunftsland',
        'nameEn': 'Origin country',
        'required': false,
        'type': {
          'id': 'list',
          'type': {
            'id': 'country',
            'unitType': 'arealDensity',
            'attributes': [],
          },
        },
      },
      'components': {
        'nameDe': 'Komponenten',
        'required': false,
        'type': {
          'id': 'list',
          'type': {
            'attributes': [
              {
                'required': true,
                'id': 'name (de)',
                'nameEn': null,
                'nameDe': 'Name (De)',
                'type': {'id': 'text', 'multiline': false},
              },
              {
                'type': {'multiline': false, 'id': 'text'},
                'nameDe': 'Name (En)',
                'nameEn': null,
                'id': 'name (en)',
                'required': false,
              },
              {
                'id': 'share',
                'nameDe': 'Anteil',
                'nameEn': 'Share',
                'type': {'id': 'number', 'unitType': 'proportion'},
                'required': true,
              },
            ],
            'id': 'object',
          },
        },
        'nameEn': 'Components',
        'id': 'components',
      },
    };

    final shortened = original.removeKeys({'required', 'multiline', 'nameEn'});

    final count = jsonEncode(original).length - jsonEncode(shortened).length;
    print('shaved $count chatacters');
    print(shortened);

    expect(jsonEncode(shortened).length < jsonEncode(original).length, true);
  });
}
