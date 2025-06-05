import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userChangesProvider = StreamProvider((ref) {
  return FirebaseAuth.instance.userChanges();
});

final userProvider = NotifierProvider.autoDispose(UserNotifier.new);

class UserNotifier extends AutoDisposeNotifier<User?> {
  @override
  User? build() {
    ref.watch(userChangesProvider);
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> signUp({
    String? name,
    required String email,
    required String password,
  }) async {
    final credentials = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await credentials.user?.updateDisplayName(name);
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
