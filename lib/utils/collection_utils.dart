extension MapExtension<K, V> on Map<K, V> {
  Map<T, V> mapKeys<T>(T Function(K key) convert) {
    return map((key, value) => MapEntry(convert(key), value));
  }

  Map<K, T> mapValues<T>(T Function(V value) convert) {
    return map((key, value) => MapEntry(key, convert(value)));
  }

  Map<K, V> whereKeys(bool Function(K key) test) {
    return where((key, _) => test(key));
  }

  Map<K, V> whereValues(bool Function(V value) test) {
    return where((_, value) => test(value));
  }

  Map<K, V> where(bool Function(K key, V value) test) {
    final result = <K, V>{};
    forEach((key, value) {
      if (test(key, value)) {
        result[key] = value;
      }
    });
    return result;
  }
}

extension JsonExtension on Map<String, dynamic> {
  Map<String, dynamic> removeKeys(Set<String> keys, [bool recursive = true]) {
    final result = Map<String, dynamic>.from(this);
    result.removeWhere((key, value) => keys.contains(key));

    if (!recursive) return result;

    return result.map((key, value) {
      if (value is Map<String, dynamic>) {
        return MapEntry(key, value.removeKeys(keys, recursive));
      } else if (value is List) {
        return MapEntry(
          key,
          value.map((item) {
            if (item is Map<String, dynamic>) {
              return item.removeKeys(keys, recursive);
            }
            return item;
          }).toList(),
        );
      }
      return MapEntry(key, value);
    });
  }
}
