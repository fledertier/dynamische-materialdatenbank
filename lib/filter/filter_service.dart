import 'package:dynamische_materialdatenbank/types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filterServiceProvider = Provider((ref) => FilterService());

class FilterService {
  List<Json> filter(List<Json> materials, Json options) {
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
