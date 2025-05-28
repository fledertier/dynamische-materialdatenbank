import '../types.dart';
import 'attribute_type.dart';

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

  String get name => nameDe ?? nameEn ?? 'Unnamed';

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
