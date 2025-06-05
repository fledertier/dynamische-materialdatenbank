import 'package:dynamische_materialdatenbank/attributes/attribute_type.dart';
import 'package:dynamische_materialdatenbank/types.dart';

class Attribute {
  const Attribute({
    required this.id,
    this.nameDe,
    this.nameEn,
    required this.type,
    this.required = false,
  });

  final String id;
  final String? nameDe;
  final String? nameEn;
  final AttributeType type;
  final bool required;

  String? get name => nameDe ?? nameEn;

  Attribute copyWith({
    String? id,
    String? nameDe,
    String? nameEn,
    AttributeType? type,
    bool? required,
  }) {
    return Attribute(
      id: id ?? this.id,
      nameDe: nameDe ?? this.nameDe,
      nameEn: nameEn ?? this.nameEn,
      type: type ?? this.type,
      required: required ?? this.required,
    );
  }

  factory Attribute.fromJson(Json json) {
    return Attribute(
      id: json['id'],
      nameDe: json['nameDe'],
      nameEn: json['nameEn'],
      type: AttributeType.fromJson(json['type']),
      required: json['required'],
    );
  }

  Json toJson() {
    return {
      'id': id,
      'nameDe': nameDe,
      'nameEn': nameEn,
      'type': type.toJson(),
      'required': required,
    };
  }

  @override
  String toString() {
    return 'Attribute(id: $id, nameDe: $nameDe, nameEn: $nameEn, type: $type, required: $required)';
  }

  @override
  bool operator ==(Object other) {
    return other is Attribute &&
        id == other.id &&
        nameDe == other.nameDe &&
        nameEn == other.nameEn &&
        type == other.type &&
        required == other.required;
  }

  @override
  int get hashCode {
    return Object.hash(id, nameDe, nameEn, type, required);
  }
}
