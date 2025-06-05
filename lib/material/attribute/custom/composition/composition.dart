import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/composition/material_category.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/composition/proportion.dart';

class Composition extends Proportion {
  Composition({required this.category, required super.share})
    : super(
        nameDe: category.nameDe,
        nameEn: category.nameEn,
        color: category.color,
      );

  final MaterialCategory category;

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
