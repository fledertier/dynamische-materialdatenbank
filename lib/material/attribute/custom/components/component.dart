import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/composition/proportion.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';

class Component extends Proportion {
  const Component({
    required this.id,
    required super.nameDe,
    required super.nameEn,
    required super.share,
  });

  final String id;

  factory Component.fromJson(Json json) {
    final name = TranslatableText.fromJson(json[Attributes.componentName]);
    return Component(
      id: json[Attributes.componentId],
      nameDe: name.valueDe ?? '',
      nameEn: name.valueEn,
      share: UnitNumber.fromJson(json[Attributes.componentShare]).value,
    );
  }

  Json toJson() {
    return {
      Attributes.componentId: id,
      Attributes.componentName:
          TranslatableText(valueDe: nameDe, valueEn: nameEn).toJson(),
      Attributes.componentShare: UnitNumber(value: share).toJson(),
    };
  }

  @override
  int get hashCode {
    return Object.hash(id, nameDe, nameEn, share);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Component) return false;

    return id == other.id &&
        nameDe == other.nameDe &&
        nameEn == other.nameEn &&
        share == other.share;
  }
}
