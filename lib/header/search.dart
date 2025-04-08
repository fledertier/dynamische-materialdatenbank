import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/attribute_provider.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final names = ref.watch(attributeProvider('name')).value ?? {};
        return SizedBox(
          width: 720,
          child: SearchAnchor(
            builder: (context, controller) {
              return SearchBar(
                leading: Icon(Icons.search),
                hintText: 'Search in materials',
                controller: controller,
                onTap: () => controller.openView(),
                onChanged: (value) => controller.openView(),
              );
            },
            suggestionsBuilder: (context, controller) {
              final query = controller.text;
              if (query.isEmpty) {
                return [];
              }
              final suggestions = search(names, query);
              return [
                for (final suggestion in suggestions)
                  ListTile(
                    title: Text(suggestion.value),
                    onTap: () {
                      controller.closeView(suggestion.value);
                      context.pushNamed(
                        'details',
                        pathParameters: {'materialId': suggestion.key},
                      );
                    },
                  ),
              ];
            },
          ),
        );
      },
    );
  }

  List<MapEntry<String, dynamic>> search(
    Map<String, dynamic> names,
    String query,
  ) {
    return names.entries.where((entry) {
      return entry.value.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
