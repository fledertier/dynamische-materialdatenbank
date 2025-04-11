class FilterState {
  bool? recyclable;
  bool? biodegradable;
  bool? biobased;
  String? manufacturer;
  double? weight;

  @override
  bool operator ==(Object other) {
    return other is FilterState &&
        other.recyclable == recyclable &&
        other.biodegradable == biodegradable &&
        other.biobased == biobased &&
        other.manufacturer == manufacturer &&
        other.weight == weight;
  }

  @override
  int get hashCode {
    return Object.hash(
      recyclable,
      biodegradable,
      biobased,
      manufacturer,
      weight,
    );
  }
}
