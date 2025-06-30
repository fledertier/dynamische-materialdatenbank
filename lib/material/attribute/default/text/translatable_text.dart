import 'package:dynamische_materialdatenbank/attributes/attributeValue.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/localization/language_button.dart';
import 'package:dynamische_materialdatenbank/utils/text_utils.dart';

class TranslatableText extends AttributeValue<TranslatableText> {
  TranslatableText({this.valueDe, this.valueEn});

  final String? valueDe;
  final String? valueEn;

  @Deprecated('Use resolve instead')
  String get value {
    return valueDe ?? valueEn ?? '';
  }

  String? resolve(Language language) {
    return switch (language) {
      Language.de => valueDe,
      Language.en => valueEn,
    };
  }

  factory TranslatableText.fromJson(Json json) {
    return TranslatableText(valueDe: json['valueDe'], valueEn: json['valueEn']);
  }

  Json toJson() => {'valueDe': valueDe, 'valueEn': valueEn};

  TranslatableText copyWithLanguage(Language language, String? value) {
    return TranslatableText(
      valueDe: language == Language.de ? value : valueDe,
      valueEn: language == Language.en ? value : valueEn,
    );
  }

  TranslatableText copyWith({String? valueDe, String? valueEn}) {
    return TranslatableText(
      valueDe: valueDe ?? this.valueDe,
      valueEn: valueEn ?? this.valueEn,
    );
  }

  @override
  String toString() {
    return 'TranslatableText(valueDe: $valueDe, valueEn: $valueEn)';
  }

  @override
  int get hashCode => Object.hash(valueDe, valueEn);

  @override
  bool operator ==(Object other) {
    return other is TranslatableText &&
        other.valueDe == valueDe &&
        other.valueEn == valueEn;
  }

  @override
  bool equals(TranslatableText other) {
    return (valueDe?.equalsIgnoreCase(other.valueDe) ?? false) ||
        (valueEn?.equalsIgnoreCase(other.valueEn) ?? false);
  }

  @override
  bool contains(TranslatableText other) {
    return (valueDe?.containsIgnoreCase(other.valueDe) ?? false) ||
        (valueEn?.containsIgnoreCase(other.valueEn) ?? false);
  }

  @override
  int compareTo(TranslatableText other) {
    // todo: compare language dependant
    return (valueDe ?? '').compareTo(other.valueDe ?? '');
  }
}
