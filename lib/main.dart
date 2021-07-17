import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upcharika/Dashboard.dart';
import 'package:upcharika/HeartRate.dart';
import 'package:upcharika/Home.dart';
import 'package:upcharika/Level.dart';

import 'onboardingScreen.dart';

int firstRun; // variable which will decide where our app will go
Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // this is used to bind the Framework to Flutter engine
  SharedPreferences prefs = await SharedPreferences.getInstance();
  firstRun = prefs.getInt("firstRun"); // getting the value of variable firstRun
  await prefs.setInt(
      "firstRun", 1); // setting 1 to the location of firstRun variable
  print('firstRun $firstRun');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upcharika',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      // making the route where the app will be directed
      // if firstRun is null or 0 route will set to first or if other than that so it will set to other
      initialRoute: firstRun == 0 || firstRun == null ? "first" : "other",
      routes: {
        // if route is first then move to OnboardingScreen
        "first": (context) => OnboardingScreen(),
        // if route is other then move to BottomNavbar
        "other": (context) => BottomNavbar(),
      },
    );
  }
}

// ------------------this class is for bottom navigation------------
class BottomNavbar extends StatefulWidget {
  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    MyHomePage(),
    Dashboard(),
    HeartRate(),
    Level(),
  ];

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcharika'),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTappedBar,
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home_outlined, color: Colors.black),
            activeIcon: Icon(
              Icons.home_outlined,
              color: Colors.blue,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Dashboard',
            icon: Icon(Icons.account_box_outlined, color: Colors.black),
            activeIcon: Icon(
              Icons.account_box_outlined,
              color: Colors.blue,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Heart Rate',
            icon: Icon(
              Icons.rate_review_outlined,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.rate_review_outlined,
              color: Colors.blue,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Spo2 Level',
            icon: Icon(
              Icons.analytics_outlined,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.analytics_outlined,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
