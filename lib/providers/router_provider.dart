import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../attributes/attributes_page.dart';
import '../constants.dart';
import '../materials_page.dart';
import '../material_detail_page.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: "/materials",
    routes: [
      GoRoute(
        path: "/materials",
        name: Pages.materials.name,
        builder: (context, state) => const MaterialsPage(),
        routes: [
          GoRoute(
            path: ":materialId",
            name: Pages.material.name,
            builder: (context, state) {
              final materialId = state.pathParameters['materialId']!;
              return MaterialDetailPage(materialId: materialId);
            },
          ),
        ],
      ),
      GoRoute(
        path: "/attributes",
        name: Pages.attributes.name,
        builder: (context, state) => const AttributesPage(),
      )
    ],
  );
});
