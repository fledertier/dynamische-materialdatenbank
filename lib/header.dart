import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Expanded(
          child: Center(
            child: SizedBox(
              width: 720,
              child: SearchBar(
                leading: Icon(Icons.search),
                hintText: 'Search in materials',
              ),
            ),
          ),
        ),
        CircleAvatar(child: Icon(Icons.person)),
      ],
    );
  }
}
