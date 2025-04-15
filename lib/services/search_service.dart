import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchServiceProvider = Provider((ref) => SearchService());

class SearchService {
  List<Map<String, dynamic>> search(
    List<Map<String, dynamic>> materials,
    Iterable<String> attributes,
    String query,
  ) {
    if (query.isEmpty) {
      return materials;
    }
    return materials.where((material) {
      return attributes.any((attribute) {
        if (material[attribute] == null) {
          return false;
        }
        return material[attribute].toLowerCase().contains(query.toLowerCase());
      });
    }).toList();
  }
}
