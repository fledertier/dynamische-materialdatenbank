import 'package:dynamische_materialdatenbank/attributes/attributeValue.dart';
import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';

class UnitNumber extends AttributeValue<UnitNumber> {
  UnitNumber({required this.value, this.displayUnit});

  final num value;
  final String? displayUnit;

  factory UnitNumber.fromJson(Json json) {
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

  @override
  bool greaterThan(UnitNumber other) {
    return value > other.value;
  }

  @override
  bool lessThan(UnitNumber other) {
    return value < other.value;
  }

  @override
  int compareTo(UnitNumber other) {
    return value.compareTo(other.value);
  }
}
