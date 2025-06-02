import 'package:dynamische_materialdatenbank/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            ref
                .read(userProvider.notifier)
                .signIn(
                  email: 'leon.martin@stud.hs-hannover.de',
                  password: 'passwort',
                );
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
