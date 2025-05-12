import 'package:dynamische_materialdatenbank/utils/miscellaneous_utils.dart';
import 'package:dynamische_materialdatenbank/widgets/directional_menu_anchor.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return DirectionalMenuAnchor(
      directionality: TextDirection.rtl,
      menuChildren: [
        ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text('Leon Martin'),
          subtitle: Text('Admin'),
        ),
        MenuItemButton(
          leadingIcon: Icon(Icons.logout),
          requestFocusOnHover: false,
          child: Text('Logout'),
          onPressed: () {},
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
