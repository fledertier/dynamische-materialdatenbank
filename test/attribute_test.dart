import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
import 'package:dynamische_materialdatenbank/utils/attribute_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('getAttribute()', () async {
    final attributeJson = {
      'id': 'list',
      'nameEn': null,
      'nameDe': 'Liste',
      'type': {
        'id': 'list',
        'attribute': {
          'id': 'item',
          'required': false,
          'type': {'id': 'number', 'unitType': null},
          'nameDe': 'Item',
          'nameEn': null,
        },
      },
      'required': false,
    };

    final attributes = {'list': Attribute.fromJson(attributeJson)};

    final attribute = getAttribute(attributes, AttributePath('list'));
    expect(attribute?.nameDe, 'Liste');

    final attribute1 = getAttribute(attributes, AttributePath('list.item'));
    expect(attribute1?.nameDe, 'Item');
  });
}
