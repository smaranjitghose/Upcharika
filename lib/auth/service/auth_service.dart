import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  Stream<String> get onAuthStateChanged =>
      auth.authStateChanges().map((User user) => user?.uid);

  Future<String> login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user.uid;
    } catch (e) {
      throw e;
    }
  }

  Future<String> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user.uid;
    } catch (e) {
      throw e;
    }
  }

  Future continueWithGoogle() async {}
  Future continueWithFacebook() async {}
  Future continueWithApple() async {}

  Future<void> signOut() async => await auth.signOut();
}
