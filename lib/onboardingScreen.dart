import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:upcharika/Home.dart';


import 'Home.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var topPadding = MediaQuery.of(context).padding.top;
    List images = [
      'assets/onboard1.png',
      'assets/onboard2.png',
      'assets/onboard3.png'
    ];
    List description = [
      'Check your Heart Rate and SpO 2 using\nsmartphone camera',
      'A unique flutter application aimed at helping\npeople getting their vitals using\nPhotoplethysmography and Computer Vision',
      'Made with ❤️ in Open Source by 🇮🇳'
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05,
              vertical: size.height * 0.02,
            ),
            height: (size.height - topPadding),
            child: Column(
              children: [
                Expanded(
                  child: Swiper(
                    autoplay: true,
                    duration: 800,
                    // loop: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(images[index]),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            description[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      );
                    },
                    itemCount: images.length,
                    pagination: SwiperPagination(
                      builder: DotSwiperPaginationBuilder(
                        color: Colors.grey,
                        activeColor: Colors.blue,
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.all(20),
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => BottomNavbar()),
                        (route) => false);
                  },
                  child: Text(
                    'Get started',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
