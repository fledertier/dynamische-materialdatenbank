import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/user/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _nameController = TextEditingController();
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
                    decoration: const InputDecoration(
                      labelText: 'Name (optional)',
                    ),
                    autofillHints: const [AutofillHints.name],
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    autofillHints: const [AutofillHints.email],
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    autofillHints: const [AutofillHints.newPassword],
                    controller: _passwordController,
                    obscureText: true,
                    onFieldSubmitted: (value) => signUp(),
                  ),
                  SizedBox(height: 64),
                  SizedBox(
                    height: 48,
                    child: FilledButton.tonal(
                      child: const Text('Sign up'),
                      onPressed: () => signUp(),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextButton(
                    child: const Text('Already have an account? Sign in here'),
                    onPressed: () => context.goNamed(Pages.signIn),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signUp() async {
    try {
      final userNotifier = ref.read(userProvider.notifier);
      await userNotifier.signUp(
        name: _nameController.text.isNotEmpty ? _nameController.text : null,
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
