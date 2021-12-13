import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:upcharika/auth/service/auth_service.dart';
import 'package:upcharika/main.dart';

class SocialAuth extends StatelessWidget {
  SocialAuth({Key key}) : super(key: key);
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GoogleAuthButton(
            onPressed: () async {
              await authService.continueWithGoogle();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => BottomNavbar()),
                  (route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }
}
