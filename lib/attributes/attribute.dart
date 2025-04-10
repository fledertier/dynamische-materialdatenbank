import 'attribute_type.dart';

class Attribute {
  final String id;
  final String name;
  final AttributeType type;
  final bool required;

  const Attribute({
    required this.id,
    required this.name,
    required this.type,
    required this.required,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      id: json['id'],
      name: json['name'],
      type: AttributeType.fromJson(json['type']),
      required: json['required'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toJson(),
      'required': required,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Attribute) return false;
    return id == other.id && name == other.name && type == other.type && required == other.required;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ type.hashCode ^ required.hashCode;
}

class CreateAttribute {
  final String name;
  final AttributeType type;
  final bool required;

  const CreateAttribute({
    required this.name,
    required this.type,
    required this.required,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.toJson(),
      'required': required,
    };
  }
}

class UpdateAttribute {
  final String id;
  final String? name;
  final bool? required;

  const UpdateAttribute({
    required this.id,
    this.name,
    this.required,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (required != null) 'required': required,
    };
  }
}
