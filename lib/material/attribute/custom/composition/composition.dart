import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/composition/material_category.dart';
import 'package:dynamische_materialdatenbank/material/attribute/custom/composition/proportion.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/number/unit_number.dart';
import 'package:dynamische_materialdatenbank/material/attribute/default/text/translatable_text.dart';

class CompositionElement extends Proportion {
  CompositionElement({required this.category, required super.share})
    : super(
        name: TranslatableText(
          valueDe: category.nameDe,
          valueEn: category.nameEn,
        ),
        color: category.color,
      );

  final MaterialCategory category;

  factory CompositionElement.fromJson(Json json) {
    return CompositionElement(
      category: MaterialCategory.values.byName(
        TranslatableText.fromJson(json[Attributes.compositionCategory]).value,
      ),
      share: UnitNumber.fromJson(json[Attributes.compositionShare]),
    );
  }

  Json toJson() {
    final categoryName = TranslatableText.fromValue(category.name);
    return {
      Attributes.compositionCategory: categoryName.toJson(),
      Attributes.compositionShare: share.toJson(),
    };
  }

  @override
  int get hashCode {
    return Object.hash(category, share);
  }

  @override
  bool operator ==(Object other) {
    return other is CompositionElement &&
        category == other.category &&
        share == other.share;
  }
}
