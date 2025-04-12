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
    return NavigationRail(
      labelType: NavigationRailLabelType.all,
      // backgroundColor: Color(0xfff2ecee),
      selectedIconTheme: IconThemeData(fill: 1),
      selectedIndex: pages.indexOf(page),
      onDestinationSelected: (index) {
        context.goNamed(pages[index]);
      },
      leading: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 16),
        child: FloatingActionButton(
          elevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          focusElevation: 0,
          backgroundColor: Color(0xfff1d3f9),
          onPressed: () {},
          child: const Icon(Symbols.add),
        ),
      ),
      destinations: [
        NavigationRailDestination(
          icon: Icon(Symbols.interests_rounded),
          label: Text("Materials"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.change_history_rounded),
          label: Text("Attributes"),
        ),
      ],
    );
  }
}
