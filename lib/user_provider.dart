import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = StreamProvider((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final userProvider = NotifierProvider.autoDispose(UserNotifier.new);

class UserNotifier extends AutoDisposeNotifier<User?> {
  @override
  User? build() {
    ref.watch(authStateProvider);
    return FirebaseAuth.instance.currentUser;
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() {
    return FirebaseAuth.instance.signOut();
  }
}
