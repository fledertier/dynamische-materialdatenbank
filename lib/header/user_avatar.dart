import 'package:dynamische_materialdatenbank/user_provider.dart';
import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:dynamische_materialdatenbank/widgets/directional_menu_anchor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserAvatar extends ConsumerWidget {
  const UserAvatar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return DirectionalMenuAnchor(
      directionality: TextDirection.rtl,
      menuChildren: [
        ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text(user?.displayName ?? user?.email ?? ''),
          subtitle: Text('Admin'),
        ),
        MenuItemButton(
          leadingIcon: Icon(Icons.logout),
          requestFocusOnHover: false,
          child: Text('Sign out'),
          onPressed: () {
            ref.read(userProvider.notifier).signOut();
          },
        ),
      ],
      builder: (context, controller, child) {
        return CircleAvatar(
          child: IconButton(
            icon: Icon(Icons.person),
            onPressed: controller.toggle,
          ),
        );
      },
    );
  }
}
