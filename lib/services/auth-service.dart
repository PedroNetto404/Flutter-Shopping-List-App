import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_shopping_list_app/services/storage-service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final StorageService storageService = StorageService();

  static AuthService? _instance;

  AuthService._();

  factory AuthService() {
    _instance ??= AuthService._();
    return _instance!;
  }

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get userChanges => firebaseAuth.authStateChanges();

  bool get isAuthenticated => currentUser != null;

  Future<void> signIn(
          {required String email, required String password}) async =>
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

  Future<void> create(
      {required String email,
      required String password,
      required String name}) async {
    final userCredentials = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    await userCredentials.user!.updateDisplayName(name);
  }

  Future<void> signOut() async => await firebaseAuth.signOut();

  Future<void> sendPasswordResetEmail({required String email}) async =>
      await firebaseAuth.sendPasswordResetEmail(email: email);

  Future<void> updateProfilePicture(File file) async {
    var url = await storageService.uploadFile(
        'users/${currentUser!.uid}/profile-picture', file);
    await currentUser!.updatePhotoURL(url);
  }
}
