import 'package:dynamische_materialdatenbank/types.dart';

class UnitNumber {
  UnitNumber({required this.value, this.unit});

  final num value;
  final String? unit;

  factory UnitNumber.fromJson(Json? json) {
    if (json == null) {
      return UnitNumber(value: 0);
    }
    return UnitNumber(value: json['value'], unit: json['unit']);
  }

  Json toJson() {
    return {'value': value, 'unit': unit};
  }

  UnitNumber copyWith({num? value, String? unit}) {
    return UnitNumber(value: value ?? this.value, unit: unit ?? this.unit);
  }

  @override
  int get hashCode {
    return Object.hash(value, unit);
  }

  @override
  bool operator ==(Object other) {
    return other is UnitNumber && other.value == value && other.unit == unit;
  }
}
