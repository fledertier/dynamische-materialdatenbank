import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'constants.dart';

class Navigation extends StatelessWidget {
  static const pages = [Pages.materials, Pages.attributes];

  const Navigation({super.key, required this.page});

  final String page;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: pages.indexOf(page),
      onDestinationSelected: (index) {
        context.goNamed(pages[index]);
      },
      children: [
        SizedBox(height: 14),
        NavigationDrawerDestination(
          icon: Icon(Symbols.interests_rounded),
          selectedIcon: Icon(Symbols.interests_rounded, fill: 1),
          label: Text("Materials"),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.change_history_rounded),
          selectedIcon: Icon(Icons.change_history_rounded, fill: 1),
          label: Text("Attributes"),
        ),
      ],
    );
  }
}
