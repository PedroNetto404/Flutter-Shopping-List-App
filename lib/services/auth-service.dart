import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'storage-service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final StorageService _storageService = StorageService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  static AuthService? _instance;

  AuthService._();

  factory AuthService() {
    _instance ??= AuthService._();
    return _instance!;
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> signIn(String email, String password) async =>
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

  Future<void> create(String email, String password, String name) async {
    final userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    await userCredentials.user!.updateDisplayName(name);
  }

  Future<void> signOut() async => await _firebaseAuth.signOut();

  Future<void> sendPasswordResetEmail({required String email}) async =>
      await _firebaseAuth.sendPasswordResetEmail(email: email);

  Future<void> updateProfilePicture(Uint8List fileBytes) async {
    var url = await _storageService.uploadFile(
        'users/${currentUser!.uid}/profile-picture', fileBytes, 'image/jpeg');
    await currentUser!.updatePhotoURL(url);
  }

  Future<void> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _firebaseAuth.signInWithCredential(credential);
  }
}
