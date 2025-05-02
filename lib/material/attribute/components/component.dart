import '../../../types.dart';

class Component {
  const Component({required this.id, required this.name, required this.share});

  final String id;
  final String name;
  final num share;

  factory Component.fromJson(Json json) {
    return Component(
      id: json['id'],
      name: json['name'] as String,
      share: json['share'] as num,
    );
  }

  Json toJson() {
    return {'id': id, 'name': name, 'share': share};
  }

  @override
  int get hashCode {
    return Object.hash(id, name, share);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Component) return false;

    return id == other.id && name == other.name && share == other.share;
  }
}
