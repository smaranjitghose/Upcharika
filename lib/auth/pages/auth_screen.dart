import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:upcharika/auth/widgets/auth_form_fields.dart';
import 'package:upcharika/auth/widgets/social_auth.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key key}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              Image.asset("assets/login.png"),
              AuthFormFields(),
              DividerWithText(text: "Or continue with"),
              SocialAuth(),
            ],
          ),
        ),
      ),
    );
  }
}



class DividerWithText extends StatelessWidget {
  const DividerWithText({Key key, @required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(thickness: 2)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(child: Divider(thickness: 2)),
      ],
    );
  }
}
