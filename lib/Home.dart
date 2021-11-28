import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upcharika/auth/service/auth_service.dart';
import 'package:upcharika/homePage.dart';
import 'package:upcharika/models/user.dart';
import 'package:upcharika/user_page.dart';
import 'package:velocity_x/velocity_x.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String istapped = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              HomeHeader(),
              Text("Welcome to Upcharika",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
              SizedBox(
                width: 20,
                height: 20,
              ),
              Text(
                "A unique flutter application aimed at helping people getting their vitals using Photoplethysmography and Computer Vision",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 20,
                height: 20,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.all(20),
                textColor: Colors.white,
                color: context.theme.buttonColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: Text(
                  'Check Your Heart Rate',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              SizedBox(
                width: 20,
                height: 20,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.all(20),
                textColor: Colors.white,
                color: context.theme.buttonColor,
                onPressed: () {
                  setState(() {
                    istapped = 'Coming Soon.';
                  });
                },
                child: Text(
                  'Check SpO\u2082 levels',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Image(
                image: AssetImage("assets/Upcharika.png"),
                width: 300,
                height: 200,
              ),
              SizedBox(
                width: 340,
                height: 60,
              ),
              Text("Made with ❤️ in 🇮🇳")
            ],
          ),
        ),
      ),
    );
  }
}

class HomeHeader extends StatelessWidget {
  HomeHeader({Key key}) : super(key: key);
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            child: Hero(
              tag: "user-image",
              child: CircleAvatar(
                radius: 50,
                backgroundImage: auth.getUser.photoURL == null
                    ? AssetImage("assets/default_user.png")
                    : NetworkImage(auth.getUser.photoURL),
              ),
            ),
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => UserPage())),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Consumer<LocalUser>(
                  builder: (context, localUser, child) => Text(
                    "Hello, ${localUser.user.displayName}",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
