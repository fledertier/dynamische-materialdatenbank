import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/composition/proportion.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';

class Component extends Proportion {
  const Component({
    required this.id,
    required super.name,
    required super.share,
  });

  final String id;

  factory Component.fromJson(Json json) {
    return Component(
      id: json[Attributes.componentId],
      name: TranslatableText.fromJson(json[Attributes.componentName]),
      share: UnitNumber.fromJson(json[Attributes.componentShare]),
    );
  }

  Json toJson() {
    return {
      Attributes.componentId: id,
      Attributes.componentName: name.toJson(),
      Attributes.componentShare: share.toJson(),
    };
  }

  @override
  int get hashCode {
    return Object.hash(id, name, share);
  }

  @override
  bool operator ==(Object other) {
    return other is Component &&
        id == other.id &&
        name == other.name &&
        share == other.share;
  }
}
