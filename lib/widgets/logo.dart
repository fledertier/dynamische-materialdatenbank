import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ColorScheme.of(context).surfaceContainerHigh,
      ),
      child: Center(child: Text("Logo")),
    );
  }
}
