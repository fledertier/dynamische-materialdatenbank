import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';

final searchServiceProvider = Provider((ref) => SearchService());

class SearchService {
  List<Map<String, dynamic>> search(
    List<Map<String, dynamic>> materials,
    String query,
  ) {
    if (query.isEmpty) {
      return materials;
    }
    return materials.where((material) {
      return [Attributes.name, Attributes.description].any((attribute) {
        if (material[attribute] == null) {
          return false;
        }
        return material[attribute].toLowerCase().contains(query.toLowerCase());
      });
    }).toList();
  }
}
