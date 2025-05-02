import '../../../types.dart';

class Component {
  const Component({required this.name, required this.share});

  final String name;
  final num share;

  factory Component.fromJson(Json json) {
    return Component(name: json['name'] as String, share: json['share'] as num);
  }

  Json toJson() {
    return {'name': name, 'share': share};
  }

  @override
  int get hashCode {
    return Object.hash(name, share);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Component) return false;

    return name == other.name && share == other.share;
  }
}
