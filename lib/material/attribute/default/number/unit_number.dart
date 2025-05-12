import 'package:dynamische_materialdatenbank/types.dart';

class UnitNumber {
  UnitNumber({required this.value, this.displayUnit});

  final num value;
  final String? displayUnit;

  factory UnitNumber.fromJson(Json? json) {
    if (json == null) {
      return UnitNumber(value: 0);
    }
    return UnitNumber(value: json['value'], displayUnit: json['displayUnit']);
  }

  Json toJson() {
    return {'value': value, 'displayUnit': displayUnit};
  }

  UnitNumber copyWith({num? value, String? displayUnit}) {
    return UnitNumber(
      value: value ?? this.value,
      displayUnit: displayUnit ?? this.displayUnit,
    );
  }

  @override
  int get hashCode {
    return Object.hash(value, displayUnit);
  }

  @override
  bool operator ==(Object other) {
    return other is UnitNumber &&
        other.value == value &&
        other.displayUnit == displayUnit;
  }
}
