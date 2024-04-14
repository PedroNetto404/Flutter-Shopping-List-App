import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_shopping_list_app/services/storage-service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final StorageService _storageService = StorageService();

  static AuthService? _instance;

  AuthService._();

  factory AuthService() {
    _instance ??= AuthService._();
    return _instance!;
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> signIn(
          {required String email, required String password}) async =>
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

  Future<void> create(
      {required String email,
      required String password,
      required String name}) async {
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

  Future<Uint8List?> getProfilePicture() async {
    var url = currentUser!.photoURL;
    if (url == null) return null;

    return await _storageService.downloadFile(url);
  }
}
