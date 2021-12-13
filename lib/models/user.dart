import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:upcharika/auth/service/auth_service.dart';

class LocalUser extends ChangeNotifier {
  User user = AuthService().getUser;

  void set updateUser(user) {
    this.user = user;
    notifyListeners();
  }

  void reload() async {
    if (this.user == null) return;

    await this.user.reload();
    notifyListeners();
  }
}
