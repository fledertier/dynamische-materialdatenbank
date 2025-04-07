import 'package:flutter/material.dart';

import 'labeled.dart';
import 'labeled_list.dart';
import 'side_sheet.dart';

class Filters extends StatefulWidget {
  const Filters({super.key});

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  final formatController = TextEditingController(text: 'All');

  @override
  Widget build(BuildContext context) {
    return SideSheet.detached(
      title: Text('Filters'),
      topActions: [
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
        IconButton(icon: Icon(Icons.close), onPressed: () {}),
      ],
      bottomActions: [
        FilledButton(child: Text('Save'), onPressed: () {}),
        OutlinedButton(child: Text('Cancel'), onPressed: () {}),
      ],
      width: 280,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabeledList(
            label: Text('Labels'),
            children: [
              CheckboxListTile(
                title: Text('Events'),
                value: false,
                onChanged: (value) {},
              ),
              CheckboxListTile(
                title: Text('Personal'),
                value: false,
                onChanged: (value) {},
              ),
              CheckboxListTile(
                title: Text('Projects'),
                value: true,
                onChanged: (value) {},
              ),
              CheckboxListTile(
                title: Text('Reminders'),
                value: true,
                onChanged: (value) {},
              ),
              CheckboxListTile(
                title: Text('Family'),
                value: false,
                onChanged: (value) {},
              ),
              CheckboxListTile(
                title: Text('Work'),
                value: false,
                onChanged: (value) {},
              ),
            ],
          ),
          Labeled(
            label: Text('Format'),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                contentPadding: EdgeInsets.all(16),
              ),
              controller: formatController,
            ),
          ),
          LabeledList(
            label: Text('Last modified'),
            children: [
              CheckboxListTile(
                title: Text('Today'),
                value: false,
                onChanged: (value) {},
              ),
              CheckboxListTile(
                title: Text('Last week'),
                value: false,
                onChanged: (value) {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
