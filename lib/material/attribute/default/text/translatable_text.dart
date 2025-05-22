import 'package:dynamische_materialdatenbank/types.dart';

class TranslatableText {
  const TranslatableText({required this.valueDe, this.valueEn});

  final String valueDe;
  final String? valueEn;

  String get value {
    return valueDe;
  }

  factory TranslatableText.fromJson(Json json) {
    return TranslatableText(valueDe: json['valueDe'], valueEn: json['valueEn']);
  }

  Json toJson() => {'valueDe': valueDe, 'valueEn': valueEn};

  TranslatableText copyWith({String? valueDe, String? valueEn}) {
    return TranslatableText(
      valueDe: valueDe ?? this.valueDe,
      valueEn: valueEn ?? this.valueEn,
    );
  }

  @override
  int get hashCode => Object.hash(valueDe, valueEn);

  @override
  bool operator ==(Object other) {
    return other is TranslatableText &&
        other.valueDe == valueDe &&
        other.valueEn == valueEn;
  }
}
