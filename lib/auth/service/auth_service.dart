import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  Stream<String> get onAuthStateChanged =>
      auth.authStateChanges().map((User user) => user?.uid);

  User get getUser => auth.currentUser;

  Future<String> login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user.uid;
    } catch (e) {
      throw e;
    }
  }

  Future<String> signUpWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await userCredential.user.updateProfile(displayName: name);
      return userCredential.user.uid;
    } catch (e) {
      throw e;
    }
  }

  Future continueWithGoogle() async {
    GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await auth.signInWithCredential(credential);
    return userCredential.user.uid;
  }

  Future reset(String email) async =>
      await auth.sendPasswordResetEmail(email: email);

  Future<void> signOut() async => await auth.signOut();
}
