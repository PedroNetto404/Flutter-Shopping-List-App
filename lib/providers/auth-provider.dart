import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/services.dart';

class AuthProvider extends ChangeNotifier {

  AuthProvider() {
    _authService.authStateChanges.listen((user) {
      _isAuthenticated = user != null;
      notifyListeners();
    });

    _isAuthenticated = _authService.currentUser != null;
  }
  final AuthService _authService = AuthService();

  late bool _isAuthenticated;

  User? get currentUser => _authService.currentUser;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> signIn(String email, String password) async {
    await _authService.signIn(email, password);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> create(String email, String password, String name) async {
    await _authService.create(email, password, name);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _authService.sendPasswordResetEmail(email: email);
    notifyListeners();
  }

  Future<void> updateProfilePicture(Uint8List fileBytes) async {
    await _authService.updateProfilePicture(fileBytes);
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    await _authService.signInWithGoogle();
    _isAuthenticated = true;
    notifyListeners();
  }
}
