import 'package:flutter/foundation.dart';

class AttributePath {
  AttributePath.of(this.ids);

  AttributePath(String path) : ids = path.split('.');

  final List<String> ids;

  bool get isTopLevel => ids.length == 1;

  String get topLevelId => ids.first;

  AttributePath operator +(String attributeId) {
    return AttributePath.of(([...ids, attributeId]));
  }

  AttributePath operator -(String attributeId) {
    return AttributePath.of(ids.where((id) => id != attributeId).toList());
  }

  @override
  String toString() => ids.join('.');

  @override
  bool operator ==(Object other) {
    return other is AttributePath && listEquals(ids, other.ids);
  }

  @override
  int get hashCode => Object.hashAll(ids);
}
