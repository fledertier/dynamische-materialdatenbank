import 'package:collection/collection.dart';
import 'package:dynamische_materialdatenbank/units.dart';

import 'attribute_type.dart';

class Attribute {
  final String id;
  final String nameDe;
  final String? nameEn;
  final AttributeType type;
  final UnitType? unitType;
  final bool? required;

  String get name => nameDe;

  const Attribute({
    required this.id,
    required this.nameDe,
    required this.nameEn,
    required this.type,
    required this.unitType,
    required this.required,
  });

  Attribute copyWith({
    String? id,
    String? nameDe,
    String? nameEn,
    AttributeType? type,
    UnitType? unitType,
    bool? required,
  }) {
    return Attribute(
      id: id ?? this.id,
      nameDe: nameDe ?? this.nameDe,
      nameEn: nameEn ?? this.nameEn,
      type: type ?? this.type,
      unitType: unitType ?? this.unitType,
      required: required ?? this.required,
    );
  }

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      id: json['id'],
      nameDe: json['nameDe'],
      nameEn: json['nameEn'],
      type: AttributeType.fromJson(json['type']),
      unitType: UnitType.values.firstWhereOrNull(
        (value) => value.name == json['unitType'],
      ),
      required: json['required'],
    );
  }

  Map<String, dynamic> toJson() {
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
    if (identical(this, other)) return true;
    if (other is! Attribute) return false;
    return id == other.id &&
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
