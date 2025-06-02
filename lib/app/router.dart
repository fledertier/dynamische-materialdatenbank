import 'package:dynamische_materialdatenbank/attributes/attributes_page.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/login_page.dart';
import 'package:dynamische_materialdatenbank/material/material_detail_page.dart';
import 'package:dynamische_materialdatenbank/material/materials_page.dart';
import 'package:dynamische_materialdatenbank/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: '/materials',
    redirect: (context, state) {
      final user = ref.read(userProvider);
      final loggingIn = state.matchedLocation == '/login';

      if (user == null && !loggingIn) return '/login';
      if (user != null && loggingIn) return '/materials';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: Pages.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/materials',
        name: Pages.materials,
        builder: (context, state) => const MaterialsPage(),
        routes: [
          GoRoute(
            path: ':materialId',
            name: Pages.material,
            builder: (context, state) {
              final materialId = state.pathParameters['materialId']!;
              return MaterialDetailPage(materialId: materialId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/attributes',
        name: Pages.attributes,
        builder: (context, state) => const AttributesPage(),
      ),
    ],
  );
});
