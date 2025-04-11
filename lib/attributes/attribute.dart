import 'attribute_type.dart';

class Attribute {
  final String id;
  final String nameDe;
  final String? nameEn;
  final AttributeType type;
  final bool? required;

  String get name => nameDe;

  const Attribute({
    required this.id,
    required this.nameDe,
    required this.nameEn,
    required this.type,
    required this.required,
  });

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

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      id: json['id'],
      nameDe: json['nameDe'],
      nameEn: json['nameEn'],
      type: AttributeType.fromJson(json['type']),
      required: json['required'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameDe': nameDe,
      'nameEn': nameEn,
      'type': type.toJson(),
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
        required == other.required;
  }

  @override
  int get hashCode =>
      id.hashCode ^ nameDe.hashCode ^ nameEn.hashCode ^ type.hashCode ^ required.hashCode;
}
