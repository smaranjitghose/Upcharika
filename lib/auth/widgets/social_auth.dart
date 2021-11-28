import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';

class SocialAuth extends StatelessWidget {
  const SocialAuth({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GoogleAuthButton(
            onPressed: () {},
            style: AuthButtonStyle(
              buttonType: AuthButtonType.icon,
              borderRadius: 50,
            ),
          ),
          FacebookAuthButton(
            onPressed: () {},
            style: AuthButtonStyle(
              buttonType: AuthButtonType.icon,
              borderRadius: 50,
            ),
          ),
          AppleAuthButton(
            onPressed: () {},
            style: AuthButtonStyle(
              buttonType: AuthButtonType.icon,
              borderRadius: 50,
            ),
          ),
        ],
      ),
    );
  }
}