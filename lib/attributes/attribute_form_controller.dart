import 'package:dynamische_materialdatenbank/material/attribute/default/number/units.dart';
import 'package:flutter/foundation.dart';

import 'attribute.dart';
import 'attribute_type.dart';

class AttributeFormController implements Listenable {
  AttributeFormController([this.initialAttribute])
    : id = ValueNotifier(initialAttribute?.id),
      nameDe = ValueNotifier(initialAttribute?.nameDe),
      nameEn = ValueNotifier(initialAttribute?.nameEn),
      type = ValueNotifier(initialAttribute?.type.id),
      listAttribute = ValueNotifier(initialAttribute?.type.listAttribute),
      unitType = ValueNotifier(initialAttribute?.type.numberUnitType),
      objectAttributes = ValueNotifier(
        initialAttribute?.type.objectAttributes ?? [],
      ),
      multiline = ValueNotifier(initialAttribute?.type.textMultiline),
      required = ValueNotifier(initialAttribute?.required);

  final ValueNotifier<String?> id;
  final ValueNotifier<String?> nameDe;
  final ValueNotifier<String?> nameEn;
  final ValueNotifier<String?> type;
  final ValueNotifier<Attribute?> listAttribute;
  final ValueNotifier<UnitType?> unitType;
  final ValueNotifier<List<Attribute>> objectAttributes;
  final ValueNotifier<bool?> multiline;
  final ValueNotifier<bool?> required;

  final Attribute? initialAttribute;

  List<ValueNotifier> get _notifiers => [
    id,
    nameDe,
    nameEn,
    type,
    listAttribute,
    unitType,
    objectAttributes,
    multiline,
    required,
  ];

  @override
  void addListener(VoidCallback listener) {
    for (final notifier in _notifiers) {
      notifier.addListener(listener);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    for (final notifier in _notifiers) {
      notifier.removeListener(listener);
    }
  }

  void dispose() {
    for (final notifier in _notifiers) {
      notifier.dispose();
    }
  }

  @override
  int get hashCode {
    return Object.hash(
      id.value,
      nameDe.value,
      nameEn.value,
      type.value,
      listAttribute.value,
      unitType.value,
      Object.hashAll(objectAttributes.value),
      multiline.value,
      required.value,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AttributeFormController) return false;

    return id.value == other.id.value &&
        nameDe.value == other.nameDe.value &&
        nameEn.value == other.nameEn.value &&
        type.value == other.type.value &&
        listAttribute.value == other.listAttribute.value &&
        unitType.value == other.unitType.value &&
        listEquals(objectAttributes.value, other.objectAttributes.value) &&
        multiline.value == other.multiline.value &&
        required.value == other.required.value;
  }
}

extension on AttributeType {
  bool? get textMultiline {
    final type = this;
    return type is TextAttributeType ? type.multiline : null;
  }

  UnitType? get numberUnitType {
    final type = this;
    return type is NumberAttributeType ? type.unitType : null;
  }

  List<Attribute>? get objectAttributes {
    final type = this;
    return type is ObjectAttributeType ? type.attributes : null;
  }

  Attribute? get listAttribute {
    final type = this;
    return type is ListAttributeType ? type.attribute : null;
  }
}
