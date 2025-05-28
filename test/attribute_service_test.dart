import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_service.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FirebaseFirestore firestore;
  late AttributeService attributeService;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    attributeService = AttributeService(firestore);
  });

  group('Attribute deletion', () {
    test('create and delete attribute', () async {
      final dings = Attribute(
        id: 'dings',
        type: ObjectAttributeType(
          attributes: [Attribute(id: 'blub', type: BooleanAttributeType())],
        ),
      );
      await attributeService.updateAttribute(dings);
      expect(
        attributeService.getAttributesStream(),
        emits(containsPair(dings.id, dings)),
      );
      await attributeService.deleteAttribute(dings.id);
      expect(attributeService.getAttributesStream(), emits(isEmpty));
    });
  });
}
