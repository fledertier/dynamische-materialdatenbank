import 'package:flutter/material.dart';

class AttributeSearchBar extends StatelessWidget {
  const AttributeSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return SearchBar(
          controller: controller,
          leading: Icon(Icons.search),
          hintText: 'Search attribute',
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
          trailing: [
            if (controller.text.isNotEmpty)
              IconButton(icon: Icon(Icons.clear), onPressed: controller.clear),
          ],
          onChanged: onChanged,
        );
      },
    );
  }
}
