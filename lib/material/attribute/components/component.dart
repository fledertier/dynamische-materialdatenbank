import 'dart:ui' show Color;

import '../../../types.dart';
import '../composition/proportion.dart';

class Component extends Proportion {
  const Component({
    required this.id,
    required super.name,
    required super.share,
    required super.color,
  });

  final String id;

  factory Component.fromJson(Json json) {
    return Component(
      id: json['id'],
      name: json['name'] as String,
      share: json['share'] as num,
      color: Color(json['color'] as int),
    );
  }

  Json toJson() {
    return {'id': id, 'name': name, 'share': share, 'color': color.toARGB32()};
  }

  @override
  int get hashCode {
    return Object.hash(id, name, share, color);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Component) return false;

    return id == other.id &&
        name == other.name &&
        share == other.share &&
        color == other.color;
  }
}
