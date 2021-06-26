import 'package:flutter/material.dart';
import 'package:upcharika/homePage.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String istapped = '';
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

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
              color: Colors.blue,
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
              color: Colors.blue,
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


            SizedBox(
              width: 340,
              height: 300,
            ),
            Text("Made with ❤️ in 🇮🇳")
          ],
        ),
      ),
    );
  }
}
