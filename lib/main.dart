import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamische_materialdatenbank/labeled.dart';
import 'package:dynamische_materialdatenbank/labeled_list.dart';
import 'package:dynamische_materialdatenbank/side_sheet.dart';
import 'package:dynamische_materialdatenbank/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final formatController = TextEditingController(text: 'All');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildTheme(context),
      home: Scaffold(
        body: Row(
          children: [
            Expanded(child: const Center(child: Text('Hello World!'))),
            SideSheet.detached(
              title: Text('Filters'),
              actions: [
                FilledButton(onPressed: () {}, child: Text('Save')),
                OutlinedButton(onPressed: () {}, child: Text('Cancel')),
              ],
              width: 280,
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
                      contentPadding: const EdgeInsets.all(16),
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
          ],
        ),
      ),
    );
  }
}
