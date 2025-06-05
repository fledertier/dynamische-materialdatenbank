import 'package:dynamische_materialdatenbank/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'constants.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Form(
            child: AutofillGroup(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    autofillHints: const [AutofillHints.email],
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    autofillHints: const [AutofillHints.password],
                    controller: _passwordController,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    onFieldSubmitted: (value) => signIn(),
                  ),
                  SizedBox(height: 64),
                  SizedBox(
                    height: 48,
                    child: FilledButton.tonal(
                      child: const Text('Sign in'),
                      onPressed: () => signIn(),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextButton(
                    child: const Text('No account? Sign up here'),
                    onPressed: () {
                      context.goNamed(Pages.signUp);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    try {
      final userNotifier = ref.read(userProvider.notifier);
      await userNotifier.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      final message = e.message ?? 'An error occurred';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
