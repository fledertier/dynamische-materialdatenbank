import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../constants.dart';

class Navigation extends StatelessWidget {
  static const pages = [Pages.materials, Pages.attributes];

  const Navigation({super.key, required this.page});

  final String page;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      labelType: NavigationRailLabelType.all,
      unselectedLabelTextStyle: TextTheme.of(context).labelMedium?.copyWith(
        color: ColorScheme.of(context).onSurfaceVariant,
        fontWeight: FontWeight.w400,
      ),
      selectedLabelTextStyle: TextTheme.of(context).labelMedium?.copyWith(
        color: ColorScheme.of(context).onSurface,
        fontWeight: FontWeight.w400,
      ),
      selectedIconTheme: IconThemeData(
        fill: 1,
        color: ColorScheme.of(context).onSecondaryContainer,
      ),
      selectedIndex: pages.indexOf(page),
      onDestinationSelected: (index) {
        context.goNamed(pages[index]);
      },
      leading: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 16),
        child: FloatingActionButton(
          heroTag: null,
          elevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          focusElevation: 0,
          onPressed: () {},
          child: const Icon(Symbols.add),
        ),
      ),
      destinations: [
        NavigationRailDestination(
          icon: Icon(Symbols.interests_rounded),
          label: Text("Materials"),
          padding: const EdgeInsets.only(top: 8),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.change_history_rounded),
          label: Text("Attributes"),
          padding: const EdgeInsets.only(top: 8),
        ),
      ],
    );
  }
}
