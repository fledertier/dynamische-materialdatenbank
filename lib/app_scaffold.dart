import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.header,
    required this.body,
    required this.sidebar,
  });

  final Widget header;
  final Widget body;
  final Widget? sidebar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          spacing: 12,
          children: [
            header,
            Expanded(
              child: Row(
                spacing: 24,
                children: [
                  Expanded(child: body),
                  if (sidebar != null) sidebar!,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
