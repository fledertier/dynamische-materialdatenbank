import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/attributes/attributes_provider.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/firestore_provider.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/material/material_provider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [firestoreProvider.overrideWithValue(FakeFirebaseFirestore())],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('attribute creation', () {
    test('create attribute', () async {
      final dings = Attribute(id: 'dings', type: NumberAttributeType());
      await container.read(attributesProvider.notifier).updateAttribute(dings);
      await expectLater(
        container.read(attributesProvider.future),
        completion(containsPair(dings.id, dings)),
      );
    });
  });

  group('attribute deletion', () {
    test('delete attribute', () async {
      final dings = Attribute(id: 'dings', type: NumberAttributeType());
      await container.read(attributesProvider.notifier).updateAttribute(dings);
      await container
          .read(attributesProvider.notifier)
          .deleteAttribute(dings.id);
      await expectLater(
        container.read(attributesProvider.future),
        completion(isEmpty),
      );
    });

    test('delete nested attribute', () async {
      final dings = Attribute(
        id: 'dings',
        type: ObjectAttributeType(
          attributes: [Attribute(id: 'blub', type: BooleanAttributeType())],
        ),
      );
      await container.read(attributesProvider.notifier).updateAttribute(dings);

      await container
          .read(attributesProvider.notifier)
          .deleteAttribute('dings.blub');

      final dingsWithoutBlub = Attribute(
        id: 'dings',
        type: ObjectAttributeType(attributes: []),
      );
      await expectLater(
        container.read(attributesProvider.future),
        completion(containsPair(dings.id, dingsWithoutBlub)),
      );
    });

    test('deleting an attribute delets its values', () async {
      final dings = Attribute(id: 'dings', type: NumberAttributeType());
      await container.read(attributesProvider.notifier).updateAttribute(dings);

      final materialId = 'material';
      final dingsValue = UnitNumber(value: 1234).toJson();
      final material = {Attributes.id: materialId, dings.id: dingsValue};
      await container
          .read(materialProvider(materialId).notifier)
          .updateMaterial(material);

      await expectLater(
        container.read(materialProvider(materialId).future),
        completion(containsPair(dings.id, dingsValue)),
      );
      await expectLater(
        container.read(jsonValuesProvider(dings.id).future),
        completion(containsPair(materialId, dingsValue)),
      );

      await container
          .read(attributesProvider.notifier)
          .deleteAttribute(dings.id);
      await expectLater(
        container.read(materialProvider(materialId).future),
        completion(isNot(containsPair(dings.id, dingsValue))),
      );
      await expectLater(
        container.read(jsonValuesProvider(dings.id).future),
        completion(isEmpty),
      );
    });
  });
}
