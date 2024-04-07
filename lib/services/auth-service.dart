import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User get currentUser {
    var currentUser = _firebaseAuth.currentUser;

    if(currentUser == null) {
      throw Exception('User not authenticated');
    }

    return currentUser;
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signIn(
          {required String email, required String password}) async =>
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

  Future<void> create(
          {required String email, required String password}) async =>
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

  Future<void> signOut() async => await _firebaseAuth.signOut();

  Future<void> sendPasswordResetEmail({required String email}) async =>
      await _firebaseAuth.sendPasswordResetEmail(email: email);
}
