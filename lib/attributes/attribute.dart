import 'package:dynamische_materialdatenbank/utils.dart';

import '../units.dart';
import 'attribute_type.dart';

class Attribute extends AttributeData {
  final String id;

  String get name => nameDe;

  @override
  String get nameDe => super.nameDe!;

  @override
  AttributeType get type => super.type!;

  @override
  bool get required => super.required ?? false;

  const Attribute({
    required this.id,
    required super.nameDe,
    required super.nameEn,
    required super.type,
    required super.unitType,
    required super.required,
  });

  factory Attribute.fromData(String id, AttributeData data) {
    return Attribute(
      id: id,
      nameDe: data.nameDe,
      nameEn: data.nameEn,
      type: data.type,
      unitType: data.unitType,
      required: data.required,
    );
  }

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      id: json['id'],
      nameDe: json['nameDe'],
      nameEn: json['nameEn'],
      type: AttributeType.fromJson(json['type']),
      unitType: unitTypeFromName(json['unitType']),
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
  Attribute copyWith({
    String Function()? id,
    String? Function()? nameDe,
    String? Function()? nameEn,
    AttributeType? Function()? type,
    UnitType? Function()? unitType,
    bool? Function()? required,
  }) {
    return Attribute.fromData(
      id != null ? id() : this.id,
      super.copyWith(
        nameDe: nameDe,
        nameEn: nameEn,
        type: type,
        unitType: unitType,
        required: required,
      ),
    );
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

class AttributeData {
  final String? nameDe;
  final String? nameEn;
  final AttributeType? type;
  final UnitType? unitType;
  final bool? required;

  const AttributeData({
    this.nameDe,
    this.nameEn,
    this.type,
    this.unitType,
    this.required,
  });

  factory AttributeData.fromAttribute(Attribute attribute) {
    return AttributeData(
      nameDe: attribute.nameDe,
      nameEn: attribute.nameEn,
      type: attribute.type,
      unitType: attribute.unitType,
      required: attribute.required,
    );
  }

  AttributeData copyWith({
    String? Function()? nameDe,
    String? Function()? nameEn,
    AttributeType? Function()? type,
    UnitType? Function()? unitType,
    bool? Function()? required,
  }) {
    return AttributeData(
      nameDe: nameDe != null ? nameDe() : this.nameDe,
      nameEn: nameEn != null ? nameEn() : this.nameEn,
      type: type != null ? type() : this.type,
      unitType: unitType != null ? unitType() : this.unitType,
      required: required != null ? required() : this.required,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AttributeData) return false;
    return nameDe == other.nameDe &&
        nameEn == other.nameEn &&
        type == other.type &&
        unitType == other.unitType &&
        required == other.required;
  }

  @override
  int get hashCode {
    return Object.hash(nameDe, nameEn, type, unitType, required);
  }
}
