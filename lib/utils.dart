import 'package:uuid/uuid.dart';

String generateId() {
  return Uuid().v7();
}

extension StringExtension on String {
  bool containsIgnoreCase(String other) {
    return toLowerCase().contains(other.toLowerCase());
  }
}
