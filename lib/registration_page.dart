import 'package:dynamische_materialdatenbank/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'constants.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({super.key});

  @override
  ConsumerState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
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
                    decoration: const InputDecoration(labelText: 'Name'),
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
                    onFieldSubmitted: (value) => register(),
                  ),
                  SizedBox(height: 64),
                  SizedBox(
                    height: 48,
                    child: FilledButton.tonal(
                      child: const Text('Registrieren'),
                      onPressed: () => register(),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextButton(
                    child: const Text('Already have an account? Login here'),
                    onPressed: () => context.goNamed(Pages.login),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> register() async {
    try {
      final userNotifier = ref.read(userProvider.notifier);
      await userNotifier.signUp(
        name: _nameController.text.isNotEmpty ? _nameController.text : null,
        email: _emailController.text,
        password: _passwordController.text,
      );
      TextInput.finishAutofillContext();
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
