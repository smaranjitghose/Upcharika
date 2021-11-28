import 'package:flutter/material.dart';
import 'package:upcharika/homePage.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
    );
  }
}
