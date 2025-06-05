import 'package:dynamische_materialdatenbank/attributes/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';

class Boolean implements Comparable<Boolean> {
  const Boolean({required this.value});

  final bool value;

  factory Boolean.fromJson(Json json) {
    return Boolean(value: json['value']);
  }

  Json toJson() => {'value': value};

  Boolean copyWith({bool? value}) {
    return Boolean(value: value ?? this.value);
  }

  @override
  String toString() {
    return 'Boolean(value: $value)';
  }

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Boolean && other.value == value;
  }

  @override
  int compareTo(Boolean other) {
    return value.toInt() - other.value.toInt();
  }
}
