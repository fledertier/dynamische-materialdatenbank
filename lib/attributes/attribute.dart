import 'attribute_type.dart';

class Attribute {
  final String name;
  final AttributeType type;

  const Attribute({
    required this.name,
    required this.type,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      name: json['name'],
      type: AttributeType.fromJson(json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.toJson(),
    };
  }
}