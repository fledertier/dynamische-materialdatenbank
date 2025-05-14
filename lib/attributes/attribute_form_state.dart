import 'package:dynamische_materialdatenbank/units.dart';
import 'package:flutter/foundation.dart';

import 'attribute.dart';
import 'attribute_type.dart';

class AttributeFormState implements Listenable {
  AttributeFormState(this.initialAttribute)
    : id = ValueNotifier(initialAttribute?.id),
      nameDe = ValueNotifier(initialAttribute?.nameDe),
      nameEn = ValueNotifier(initialAttribute?.nameEn),
      type = ValueNotifier(initialAttribute?.type),
      unitType = ValueNotifier(initialAttribute?.unitType),
      multiline = ValueNotifier(initialAttribute?.multiline),
      required = ValueNotifier(initialAttribute?.required);

  final ValueNotifier<String?> id;
  final ValueNotifier<String?> nameDe;
  final ValueNotifier<String?> nameEn;
  final ValueNotifier<AttributeType?> type;
  final ValueNotifier<UnitType?> unitType;
  final ValueNotifier<bool?> multiline;
  final ValueNotifier<bool?> required;

  final Attribute? initialAttribute;

  bool get hasChanges {
    return nameDe.value != initialAttribute?.nameDe ||
        nameEn.value != initialAttribute?.nameEn ||
        type.value != initialAttribute?.type ||
        unitType.value != initialAttribute?.unitType ||
        multiline.value != initialAttribute?.multiline ||
        required.value != initialAttribute?.required;
  }

  List<ValueNotifier> get _notifiers => [
    id,
    nameDe,
    nameEn,
    type,
    unitType,
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
}
