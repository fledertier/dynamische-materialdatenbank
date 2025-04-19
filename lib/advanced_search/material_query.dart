import 'condition.dart';

class MaterialQuery {
  final List<Condition> filterConditions;
  final List<Condition> searchConditions;
  final List<Condition> customConditions;

  List<Condition> get conditions => [
    ...filterConditions,
    ...searchConditions,
    ...customConditions,
  ];

  const MaterialQuery({
    this.filterConditions = const [],
    this.searchConditions = const [],
    this.customConditions = const [],
  });

  MaterialQuery copyWith({
    List<Condition>? filterConditions,
    List<Condition>? searchConditions,
    List<Condition>? customConditions,
  }) {
    return MaterialQuery(
      filterConditions: filterConditions ?? this.filterConditions,
      searchConditions: searchConditions ?? this.searchConditions,
      customConditions: customConditions ?? this.customConditions,
    );
  }
}
