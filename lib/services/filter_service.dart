import '../filter/filter_state.dart';

List<Map<String, dynamic>> filter(
  List<Map<String, dynamic>> materials,
  FilterState filterState,
) {
  if (filterState.isEmpty) {
    return materials;
  }
  return materials.where((material) {
    if (material['recyclable'] != filterState.recyclable) {
      return false;
    }
    if (material['biodegradable'] != filterState.biodegradable) {
      return false;
    }
    if (material['biobased'] != filterState.biobased) {
      return false;
    }
    if (material['manufacturer'] != filterState.manufacturer) {
      return false;
    }
    if (filterState.weight != null &&
        material['weight'] > filterState.weight!) {
      return false;
    }
    return true;
  }).toList();
}
