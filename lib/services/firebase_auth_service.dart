import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  final FirebaseAuth _authService = FirebaseAuth.instance;

  // Metode untuk mendaftar dengan email dan password
  Future<User?> signUpWithEmailAndPassword(String email, String password, BuildContext context) async {
    try {
      UserCredential credential = await _authService.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      final String errorMessage = e.toString();
      // Panggil method _showErrorSnackbar untuk menampilkan pesan error
      _showErrorSnackbar(context, errorMessage);
      return null;
    }
  }

  // Metode untuk login dengan email dan password
  Future<User?> loginWithEmailAndPassword(String email, String password, BuildContext context) async {
    try {
      UserCredential credential = await _authService.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      final String errorMessage = e.toString();
      // Panggil method _showErrorSnackbar untuk menampilkan pesan error
      _showErrorSnackbar(context, errorMessage);
      return null;
    }
  }

  // Metode untuk mendapatkan informasi user yang sedang login
  User? getCurrentUser() {
    User? currentUser = _authService.currentUser;
    return currentUser;
  }

  // Method privat untuk menampilkan Snackbar dengan pesan error
  void _showErrorSnackbar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }

}
