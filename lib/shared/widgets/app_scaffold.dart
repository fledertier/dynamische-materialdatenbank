import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.header,
    required this.body,
    this.sidebar,
    this.navigation,
    this.floatingActionButton,
  });

  final Widget header;
  final Widget body;
  final Widget? sidebar;
  final Widget? navigation;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Row(
        children: [
          ?navigation,
          Expanded(
            child: Padding(
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
                        ?sidebar,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
