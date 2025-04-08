import 'package:flutter/material.dart';

import 'search.dart';
import 'user_avatar.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [Expanded(child: Center(child: Search())), UserAvatar()],
    );
  }
}
