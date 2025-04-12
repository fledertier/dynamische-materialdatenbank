import '../filter/filter_options.dart';

List<Map<String, dynamic>> filter(
  List<Map<String, dynamic>> materials,
  FilterOptions options,
) {
  if (options.isEmpty) {
    return materials;
  }
  return materials.where((material) {
    if (material['recyclable'] != options.recyclable) {
      return false;
    }
    if (material['biodegradable'] != options.biodegradable) {
      return false;
    }
    if (material['biobased'] != options.biobased) {
      return false;
    }
    if (material['manufacturer'] != options.manufacturer) {
      return false;
    }
    if (options.weight != null && material['weight'] > options.weight!) {
      return false;
    }
    return true;
  }).toList();
}
