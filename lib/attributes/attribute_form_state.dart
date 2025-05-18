import 'package:dynamische_materialdatenbank/units.dart';
import 'package:flutter/foundation.dart';

import 'attribute.dart';
import 'attribute_type.dart';

class AttributeFormController implements Listenable {
  AttributeFormController([this.initialAttribute])
    : id = ValueNotifier(initialAttribute?.id),
      nameDe = ValueNotifier(initialAttribute?.nameDe),
      nameEn = ValueNotifier(initialAttribute?.nameEn),
      type = ValueNotifier(initialAttribute?.type.id),
      listType = ValueNotifier(initialAttribute?.type.listType?.id),
      unitType = ValueNotifier(initialAttribute?.type.numberUnitType),
      objectAttributes = ValueNotifier(
        initialAttribute?.type.objectAttributes ?? [],
      ),
      required = ValueNotifier(initialAttribute?.required);

  final ValueNotifier<String?> id;
  final ValueNotifier<String?> nameDe;
  final ValueNotifier<String?> nameEn;
  final ValueNotifier<String?> type;
  final ValueNotifier<String?> listType;
  final ValueNotifier<UnitType?> unitType;
  final ValueNotifier<List<Attribute>> objectAttributes;
  final ValueNotifier<bool?> required;

  final Attribute? initialAttribute;

  bool get hasChanges {
    return nameDe.value != initialAttribute?.nameDe ||
        nameEn.value != initialAttribute?.nameEn ||
        type.value != initialAttribute?.type.id ||
        listType.value != initialAttribute?.type.listType?.id ||
        unitType.value != initialAttribute?.type.numberUnitType ||
        !listEquals(
          objectAttributes.value,
          initialAttribute?.type.objectAttributes ?? [],
        ) ||
        required.value != initialAttribute?.required;
  }

  List<ValueNotifier> get _notifiers => [
    id,
    nameDe,
    nameEn,
    type,
    listType,
    unitType,
    objectAttributes,
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
}

extension on AttributeType {
  AttributeType? get listType {
    if (this case ListAttributeType(:final type)) {
      return type;
    }
    return null;
  }

  UnitType? get numberUnitType {
    if (this case NumberAttributeType(:final unitType)) {
      return unitType;
    }
    return null;
  }

  List<Attribute>? get objectAttributes {
    var attributeType = this;
    if (this case ListAttributeType(:final type)) {
      attributeType = type;
    }
    if (attributeType case ObjectAttributeType(:final attributes)) {
      return attributes;
    }
    return null;
  }
}
