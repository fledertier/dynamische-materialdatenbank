class FilterOptions {
  const FilterOptions({
    this.recyclable,
    this.biodegradable,
    this.biobased,
    this.manufacturer,
    this.weight,
  });

  final bool? recyclable;
  final bool? biodegradable;
  final bool? biobased;
  final String? manufacturer;
  final double? weight;

  bool get isEmpty {
    return recyclable == null &&
        biodegradable == null &&
        biobased == null &&
        manufacturer == null &&
        weight == null;
  }

  FilterOptions copyWithNullable({
    bool? Function()? recyclable,
    bool? Function()? biodegradable,
    bool? Function()? biobased,
    String? Function()? manufacturer,
    double? Function()? weight,
  }) {
    return FilterOptions(
      recyclable: recyclable != null ? recyclable() : this.recyclable,
      biodegradable:
          biodegradable != null ? biodegradable() : this.biodegradable,
      biobased: biobased != null ? biobased() : this.biobased,
      manufacturer: manufacturer != null ? manufacturer() : this.manufacturer,
      weight: weight != null ? weight() : this.weight,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FilterOptions &&
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
