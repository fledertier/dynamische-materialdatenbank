import 'package:dynamische_materialdatenbank/app/theme_mode.dart';
import 'package:dynamische_materialdatenbank/user/user_avatar.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key, this.center, this.actions});

  final Widget? center;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        spacing: 12,
        children: [
          Expanded(child: Center(child: center ?? SizedBox())),
          ...?actions,
          ThemeModeButton(),
          UserAvatar(),
        ],
      ),
    );
  }
}
