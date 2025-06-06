import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/attributes/attributes_provider.dart';
import 'package:dynamische_materialdatenbank/firestore_provider.dart';
import 'package:dynamische_materialdatenbank/material/attribute/attribute_path.dart';
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

  test('create and delete attribute', () async {
    final dings = Attribute(id: 'dings', type: NumberAttributeType());

    await container.read(attributesProvider.notifier).updateAttribute(dings);
    await expectLater(
      container.read(attributesProvider.future),
      completion(containsPair(dings.id, dings)),
    );

    await container
        .read(attributesProvider.notifier)
        .deleteAttribute(AttributePath(dings.id));
    await expectLater(
      container.read(attributesProvider.future),
      completion(isEmpty),
    );
  });
}
