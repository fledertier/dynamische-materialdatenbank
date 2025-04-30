import 'package:dynamische_materialdatenbank/header/theme_mode.dart';
import 'package:flutter/material.dart';

import '../search/material_search.dart';
import 'user_avatar.dart';

class Header extends StatelessWidget {
  const Header({super.key, this.actions, this.onFilter});

  final List<Widget>? actions;
  final void Function()? onFilter;

  @override
  Widget build(BuildContext context) {
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    return Row(
      spacing: 12,
      children: [
        canPop ? BackButton() : SizedBox.square(dimension: 40),
        Expanded(child: Center(child: MaterialSearch(onFilter: onFilter))),
        ...?actions,
        ThemeModeButton(),
        UserAvatar(),
      ],
    );
  }
}
