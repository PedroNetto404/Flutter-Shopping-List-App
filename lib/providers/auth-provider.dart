import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_shopping_list_app/services/auth-service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  late bool _isAuthenticated;

  User get currentUser => _authService.currentUser!;

  AuthProvider() {
    _isAuthenticated = _authService.currentUser != null;
  }

  bool get isAuthenticated => _isAuthenticated;

  Future<void> signIn({required String email, required String password}) async {
    await _authService.signIn(email: email, password: password);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> create(
      {required String email,
      required String password,
      required String name}) async {
    await _authService.create(email: email, password: password, name: name);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _authService.sendPasswordResetEmail(email: email);
    notifyListeners();
  }

  Future<void> updateProfilePicture(Uint8List fileBytes) async {
    await _authService.updateProfilePicture(fileBytes);
    notifyListeners();
  }
}
