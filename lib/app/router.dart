import 'package:dynamische_materialdatenbank/attributes/attributes_page.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/material/material_detail_page.dart';
import 'package:dynamische_materialdatenbank/material/materials_page.dart';
import 'package:dynamische_materialdatenbank/user/sign_in_page.dart';
import 'package:dynamische_materialdatenbank/user/sign_up_page.dart';
import 'package:dynamische_materialdatenbank/user/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: '/materials',
    redirect: (context, state) {
      final user = ref.read(userProvider);
      final signingIn = state.matchedLocation == '/sign-in';
      final signingUp = state.matchedLocation == '/sign-up';

      if (user == null && !(signingIn || signingUp)) return '/sign-in';
      if (user != null && (signingIn || signingUp)) return '/materials';

      return null;
    },
    routes: [
      GoRoute(
        path: '/sign-in',
        name: Pages.signIn,
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/sign-up',
        name: Pages.signUp,
        builder: (context, state) => const SignUpPage(),
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
