import 'package:flutter_riverpod/flutter_riverpod.dart';

final filterServiceProvider = Provider((ref) => FilterService());

class FilterService {
  List<Map<String, dynamic>> filter(
    List<Map<String, dynamic>> materials,
    Map<String, dynamic> options,
  ) {
    if (options.isEmpty) {
      return materials;
    }
    return materials.where((material) {
      for (final attribute in options.keys) {
        final filterValue = options[attribute];
        final value = material[attribute];

        if (value == null) {
          return false;
        }

        if (filterValue is double) {
          if (value > filterValue) {
            return false;
          }
        } else {
          if (value != filterValue) {
            return false;
          }
        }
      }
      return true;
    }).toList();
  }
}
