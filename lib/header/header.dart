import 'package:dynamische_materialdatenbank/header/theme_mode.dart';
import 'package:flutter/material.dart';

import 'user_avatar.dart';

class Header extends StatelessWidget {
  const Header({super.key, this.search, this.actions});

  final Widget? search;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    return Row(
      spacing: 12,
      children: [
        canPop ? BackButton() : SizedBox.square(dimension: 40),
        Expanded(child: Center(child: search ?? SizedBox())),
        ...?actions,
        ThemeModeButton(),
        UserAvatar(),
      ],
    );
  }
}
