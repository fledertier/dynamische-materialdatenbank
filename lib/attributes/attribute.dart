import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';

import '../types.dart';
import '../units.dart';
import 'attribute_type.dart';

class Attribute {
  const Attribute({
    required this.id,
    required this.nameDe,
    required this.nameEn,
    required this.type,
    required this.unitType,
    required this.required,
  });

  final String id;
  final String nameDe;
  final String? nameEn;
  final AttributeType type;
  final UnitType? unitType;
  final bool required;

  String get name => nameDe;

  factory Attribute.fromJson(Json json) {
    return Attribute(
      id: json['id'],
      nameDe: json['nameDe'],
      nameEn: json['nameEn'],
      type: AttributeType.fromJson(json['type']),
      unitType: unitTypeFromName(json['unitType']),
      required: json['required'],
    );
  }

  Json toJson() {
    return {
      'id': id,
      'nameDe': nameDe,
      'nameEn': nameEn,
      'type': type.toJson(),
      'unitType': unitType?.name,
      'required': required,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is Attribute &&
        id == other.id &&
        nameDe == other.nameDe &&
        nameEn == other.nameEn &&
        type == other.type &&
        unitType == other.unitType &&
        required == other.required;
  }

  @override
  int get hashCode {
    return Object.hash(id, nameDe, nameEn, type, unitType, required);
  }
}
