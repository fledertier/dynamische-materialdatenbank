import 'package:uuid/uuid.dart';

String generateId() {
  return Uuid().v7();
}
