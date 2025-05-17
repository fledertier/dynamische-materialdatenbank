import '../types.dart';
import '../units.dart';
import 'attribute_type.dart';

class Attribute {
  const Attribute({
    required this.id,
    required this.nameDe,
    required this.nameEn,
    required this.type,
    required this.listType,
    required this.unitType,
    required this.required,
  });

  final String id;
  final String nameDe;
  final String? nameEn;
  final AttributeType type;
  final AttributeType? listType;
  final UnitType? unitType;
  final bool required;

  String get name => nameDe;

  factory Attribute.fromJson(Json json) {
    return Attribute(
      id: json['id'],
      nameDe: json['nameDe'],
      nameEn: json['nameEn'],
      type: AttributeType.fromJson(json['type']),
      listType: AttributeType.maybeFromJson(json['listType']),
      unitType: UnitType.maybeFromJson(json['unitType']),
      required: json['required'],
    );
  }

  Json toJson() {
    return {
      'id': id,
      'nameDe': nameDe,
      'nameEn': nameEn,
      'type': type.toJson(),
      'listType': listType?.toJson(),
      'unitType': unitType?.toJson(),
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
        listType == other.listType &&
        unitType == other.unitType &&
        required == other.required;
  }

  @override
  int get hashCode {
    return Object.hash(id, nameDe, nameEn, type, listType, unitType, required);
  }
}
