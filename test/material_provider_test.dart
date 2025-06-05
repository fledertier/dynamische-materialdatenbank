import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_provider.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/attributes/attributes_provider.dart';
import 'package:dynamische_materialdatenbank/firestore_provider.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/boolean/boolean.dart';
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

  test('create and delete material', () async {
    final dings = Attribute(id: 'dings', type: NumberAttributeType());
    final dingsValue = UnitNumber(value: 1234).toJson();
    await container.read(attributesProvider.notifier).updateAttribute(dings);

    final materialId = 'material';
    final material = {dings.id: dingsValue};

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
        .read(materialProvider(materialId).notifier)
        .deleteMaterial();
    await expectLater(
      container.read(materialProvider(materialId).future),
      completion(isEmpty),
    );
    await expectLater(
      container.read(jsonValuesProvider(dings.id).future),
      completion(isEmpty),
    );
  });

  test('delete attribute', () async {
    final dings = Attribute(id: 'dings', type: NumberAttributeType());
    final dingsValue = UnitNumber(value: 1234).toJson();
    await container.read(attributesProvider.notifier).updateAttribute(dings);

    final materialId = 'material';
    final material = {dings.id: dingsValue};
    await container
        .read(materialProvider(materialId).notifier)
        .updateMaterial(material);

    await container.read(attributesProvider.notifier).deleteAttribute(dings.id);
    await expectLater(
      container.read(materialProvider(materialId).future),
      completion(isNot(containsPair(dings.id, dingsValue))),
    );
    await expectLater(
      container.read(jsonValuesProvider(dings.id).future),
      completion(isEmpty),
    );
  });

  test('delete nested attribute', () async {
    final blub = Attribute(id: 'blub', type: BooleanAttributeType());
    final dings = Attribute(
      id: 'dings',
      type: ObjectAttributeType(attributes: [blub]),
    );
    await container.read(attributesProvider.notifier).updateAttribute(dings);

    final materialId = 'material';
    final material = {
      dings.id: {blub.id: Boolean(value: true)},
    };
    await container
        .read(materialProvider(materialId).notifier)
        .updateMaterial(material);

    await container
        .read(attributesProvider.notifier)
        .deleteAttribute('dings.blub');
    await expectLater(
      container.read(materialProvider(materialId).future),
      completion(containsPair(dings.id, {})),
    );
    await expectLater(
      container.read(jsonValuesProvider(dings.id).future),
      completion(containsPair(materialId, {})),
    );
  });

  test('delete nested list attribute', () async {
    final blub = Attribute(id: 'blub', type: BooleanAttributeType());
    final dings = Attribute(
      id: 'dings',
      type: ListAttributeType(
        attribute: Attribute(
          id: 'boop',
          type: ObjectAttributeType(attributes: [blub]),
        ),
      ),
    );
    await container.read(attributesProvider.notifier).updateAttribute(dings);

    final materialId = 'material';
    final material = {
      dings.id: [
        {blub.id: Boolean(value: true).toJson()},
        {blub.id: Boolean(value: false).toJson()},
      ],
    };
    await container
        .read(materialProvider(materialId).notifier)
        .updateMaterial(material);

    await container
        .read(attributesProvider.notifier)
        .deleteAttribute('dings.boop.blub');
    await expectLater(
      container.read(materialProvider(materialId).future),
      completion(containsPair(dings.id, [{}, {}])),
    );
    await expectLater(
      container.read(jsonValuesProvider(dings.id).future),
      completion(containsPair(materialId, [{}, {}])),
    );
  });
}
