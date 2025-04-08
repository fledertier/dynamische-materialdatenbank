import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../home_page.dart';
import '../material_detail_page.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: "/",
        name: "home",
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: "materials/:materialId",
            name: "details",
            builder: (context, state) {
              final materialId = state.pathParameters['materialId']!;
              return MaterialDetailPage(materialId: materialId);
            },
          ),
        ],
      ),
    ],
  );
});
