abstract class AttributeValue<T> implements Comparable<T> {
  bool equals(T other) {
    throw UnimplementedError('equals() is not implemented for $runtimeType');
  }

  bool greaterThan(T other) {
    throw UnimplementedError(
      'greaterThan() is not implemented for $runtimeType',
    );
  }

  bool lessThan(T other) {
    throw UnimplementedError('lessThan() is not implemented for $runtimeType');
  }

  bool contains(T other) {
    throw UnimplementedError('contains() is not implemented for $runtimeType');
  }
}
