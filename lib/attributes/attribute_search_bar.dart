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
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(Icons.search),
          ),
          hintText: 'Search attribute',
          trailing: [
            if (controller.text.isNotEmpty)
              IconButton(
                icon: Icon(Icons.clear),
                tooltip: MaterialLocalizations.of(context).clearButtonTooltip,
                onPressed: controller.clear,
              ),
          ],
          onChanged: onChanged,
        );
      },
    );
  }
}
