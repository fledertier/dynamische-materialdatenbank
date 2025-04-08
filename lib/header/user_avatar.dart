import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          leadingIcon: Icon(Icons.settings),
          child: Text('Settings'),
          onPressed: () {},
        ),
        MenuItemButton(
          leadingIcon: Icon(Icons.logout),
          child: Text('Logout'),
          onPressed: () {},
        ),
      ],
      builder: (context, controller, child) {
        return CircleAvatar(
          child: IconButton(
            icon: Icon(Icons.person),
            onPressed: controller.isOpen ? controller.close : controller.open,
          ),
        );
      },
    );
  }
}
