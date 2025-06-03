import 'package:dynamische_materialdatenbank/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
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
                    autofocus: true,
                  ),
                  SizedBox(height: 32),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    autofillHints: const [AutofillHints.password],
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  SizedBox(height: 64),
                  SizedBox(
                    height: 48,
                    child: FilledButton.tonal(
                      onPressed: login,
                      child: const Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
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
