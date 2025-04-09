import 'package:flutter/material.dart';

import 'material_search.dart';
import 'user_avatar.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    return Row(
      spacing: 12,
      children: [
        canPop ? BackButton() : DrawerButton(),
        Expanded(child: Center(child: MaterialSearch())),
        UserAvatar(),
      ],
    );
  }
}
