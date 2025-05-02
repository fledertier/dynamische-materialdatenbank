import '../../../types.dart';
import 'material_category.dart';

class Composition {
  const Composition({required this.category, required this.share});

  final MaterialCategory category;
  final num share;

  factory Composition.fromJson(Json json) {
    return Composition(
      category: MaterialCategory.values.byName(json['category']),
      share: json['share'] as num,
    );
  }

  Json toJson() {
    return {'category': category.name, 'share': share};
  }

  @override
  int get hashCode {
    return Object.hash(category, share);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Composition) return false;

    return category == other.category && share == other.share;
  }
}
