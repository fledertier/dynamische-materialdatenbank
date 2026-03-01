import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_path_url_strategy/dynamic_path_url_strategy.dart';
import 'package:dynamische_materialdatenbank/core/app/app.dart';
import 'package:dynamische_materialdatenbank/shared/constants.dart';
import 'package:dynamische_materialdatenbank/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (environment == Environments.development) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  }

  GoRouter.optionURLReflectsImperativeAPIs = true;
  setPathUrlStrategy();

  runApp(ProviderScope(child: const App()));
}
