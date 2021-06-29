import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:upcharika/HeartRate.dart';
import 'package:upcharika/timer.dart';
import 'package:wakelock/wakelock.dart';
import 'chart.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageView createState() {
    return HomePageView();
  }
}

class HomePageView extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  // WidgetsBindingObserver is used to know if our app is in background or active or closed
  bool _toggled = false; // toggle button value
  List<SensorValue> _data = List<SensorValue>(); // array to store the values
  CameraController _controller;
  double _alpha = 0.3; // factor for the mean value
  AnimationController _animationController;
  double _buttonScale = 1;
  String buttonText = "Check Heart Rate";
  int _bpm = 0; // beats per minute
  int _fs = 30; // sampling frequency (fps)
  int _windowLen = 30 * 6; // window length to display - 6 seconds
  CameraImage _image; // store the last camera image
  double _avg; // store the average value during calculation
  DateTime _now; // store the now Datetime
  Timer _timerImage, // timer for image processing
      _timer; // timer for timer
  int seconds = 60;
  List data = [];
  bool done = true;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animationController
      ..addListener(() {
        setState(() {
          _buttonScale = 1.0 + _animationController.value * 0.4;
        });
      });
    WidgetsBinding.instance.addObserver(
        this); // here we are adding observer which will detect in which state our app exists
  }

  @override
  void dispose() {
    _timerImage?.cancel();
    _timer.cancel();
    _toggled = false;
    _disposeController();
    Wakelock.disable();
    _animationController?.stop();
    _animationController?.dispose();
    super.dispose();
    WidgetsBinding.instance
        .removeObserver(this); // removing the observer when our app is closed
  }

  // inside this method we will check our app state
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // here we are checking if the app is in inactive or detached state
    // and we are returning because we dont want to perform anything when the app is in inactive or detached state
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    // here we are checking if our state is paused which is when app moves in background
    // then assigning the boolean value to the boolean variable inbackground
    final inbackground = (state == AppLifecycleState.paused);

    // this if condition is used to perform any task if our app is in the background state
    // it checks if our app is in background or not and performs the specified task.
    if (inbackground) {
      _controller
          .setFlashMode(FlashMode.off); // this is used to stop the flash light
      _untoggle(); // to stop the BPM estimating process and animation of the button
      setState(() {
        buttonText =
            'Check Heart Rate'; // to set button text to Check Heart Rate
        _bpm =
            0; // to set _bpm to 0 when the app goes in background and BPM estimation process is stopped
        _timer.cancel(); // to cancel the timer when the app moves in background
        seconds =
            60; // setting seconds to original value after timer is stopped
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upcharika"),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(18),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            alignment: Alignment.center,
                            children: <Widget>[
                              _controller != null && _toggled
                                  ? AspectRatio(
                                      aspectRatio:
                                          _controller.value.aspectRatio,
                                      child: CameraPreview(_controller),
                                    )
                                  : Container(
                                      padding: EdgeInsets.all(12),
                                      alignment: Alignment.center,
                                      color: Colors.grey,
                                    ),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(4),
                                child: Text(
                                  _toggled
                                      ? "Cover both the camera and the flash with your finger"
                                      : "Camera feed will display here",
                                  style: TextStyle(
                                      backgroundColor: _toggled
                                          ? Colors.white
                                          : Colors.transparent),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CountDownTimer(
                            width: 150,
                            height: 150,
                            bgColor: Colors.blue[100],
                            color: Colors.blue,
                            current: seconds,
                            total: 60,
                            bpm: _bpm,
                          ),
                          // Text(
                          //   "Estimated Heart Rate(BPM)",
                          //   style: TextStyle(fontSize: 18, color: Colors.grey),
                          //   textAlign: TextAlign.center,
                          // ),
                          // Text(
                          //   (_bpm > 30 && _bpm < 150 ? _bpm.toString() : "--"),
                          //   style: TextStyle(
                          //       fontSize: 32, fontWeight: FontWeight.bold),
                          // ),
                        ],
                      )),
                    ),
                  ],
                )),
            SizedBox(
              width: 40,
              height: 40,
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Transform.scale(
                            scale: _buttonScale,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                buttonText,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              color: Colors.blue,
                              onPressed: () {
                                if (_toggled) {
                                  buttonText = "Check Heart Rate";
                                  _untoggle();
                                } else {
                                  buttonText = "Stop";
                                  _toggle();
                                }
                              },
                            ),
                          ),
                          MaterialButton(
                              child: Text(
                                "Records",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => HeartRate()));
                              }),
                        ]),
                    SizedBox(
                      width: 20,
                      height: 20,
                    ),
                    Text(
                      "Cover both the camera and the flash with your finger",
                    ),
                  ],
                ),
              ),
            ),
            Text(
              "Graph",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              width: 20,
              height: 20,
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                    color: Colors.black),
                child: Chart(_data),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearData() {
    // create array of 128 ~= 255/2
    _data.clear();
    int now = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < _windowLen; i++)
      _data.insert(
          0,
          SensorValue(
              DateTime.fromMillisecondsSinceEpoch(now - i * 1000 ~/ _fs), 128));
  }

  // method to start the BPM estimating Process
  void _toggle() {
    startTimer();
    _clearData();
    _initController().then((onValue) {
      Wakelock.enable();
      _animationController?.repeat(reverse: true);
      setState(() {
        _toggled = true;
      });
      // after is toggled
      _initTimer();
      _updateBPM();
    });
  }

  // method to stop the BPM estimation process
  void _untoggle() {
    _disposeController();
    Wakelock.disable();
    _animationController?.stop();
    _animationController?.value = 0.0;
    setState(() {
      _toggled = false;
      _timer.cancel();
      seconds = 60;
    });
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
  }

  Future<void> _initController() async {
    try {
      List _cameras = await availableCameras();
      _controller = CameraController(_cameras.first, ResolutionPreset.low);
      await _controller.initialize();
      Future.delayed(Duration(milliseconds: 50)).then((onValue) {
        _controller.setFlashMode(FlashMode
            .torch); // this is used to start the flash light with a delay of 50 milliseconds.
      });
      _controller.startImageStream((CameraImage image) {
        _image = image;
      });
    } catch (Exception) {
      debugPrint(Exception);
    }
  }

  void _initTimer() {
    _timerImage = Timer.periodic(Duration(milliseconds: 1000 ~/ _fs), (timer) {
      if (_toggled) {
        if (_image != null) _scanImage(_image);
      } else {
        timer.cancel();
      }
    });
  }

  void _scanImage(CameraImage image) {
    _now = DateTime.now();
    _avg =
        image.planes.first.bytes.reduce((value, element) => value + element) /
            image.planes.first.bytes.length;
    if (_data.length >= _windowLen) {
      _data.removeAt(0);
    }
    setState(() {
      _data.add(SensorValue(_now, 255 - _avg));
    });
  }

  void _updateBPM() async {
    // Bear in mind that the method used to calculate the BPM is very rudimentar
    // feel free to improve it :)

    // Since this function doesn't need to be so "exact" regarding the time it executes,
    // I only used the a Future.delay to repeat it from time to time.
    // Ofc you can also use a Timer object to time the callback of this function
    List<SensorValue> _values;
    double _avg;
    int _n;
    double _m;
    double _threshold;
    double _bpm;
    int _counter;
    int _previous;
    while (_toggled) {
      _values = List.from(_data); // create a copy of the current data array
      _avg = 0;
      _n = _values.length;
      _m = 0;
      _values.forEach((SensorValue value) {
        _avg += value.value / _n;
        if (value.value > _m) _m = value.value;
      });
      _threshold = (_m + _avg) / 2;
      _bpm = 0;
      _counter = 0;
      _previous = 0;
      for (int i = 1; i < _n; i++) {
        if (_values[i - 1].value < _threshold &&
            _values[i].value > _threshold) {
          if (_previous != 0) {
            _counter++;
            _bpm += 60 *
                1000 /
                (_values[i].time.millisecondsSinceEpoch - _previous);
          }
          _previous = _values[i].time.millisecondsSinceEpoch;
        }
      }
      if (_counter > 0) {
        _bpm = _bpm / _counter;
        print(_bpm);
        setState(() {
          this._bpm = ((1 - _alpha) * this._bpm + _alpha * _bpm).toInt();
        });
      }
      await Future.delayed(Duration(
          milliseconds:
              1000 * _windowLen ~/ _fs)); // wait for a new set of _data values
    }
  }

  // method to start the timer of 60 sec when the checkheartrate button is pressed
  void startTimer() {
    const onesec =
        const Duration(seconds: 1); // here we are declaring the 1 second
    _timer = Timer.periodic(onesec, (Timer timer) {
      // periodic method of Timer class is used to call the method again and again at an interval of duration parameter.
      // till the timer is stopped by the cancel method
      if (seconds == 0) {
        setState(() {
          timer.cancel(); // when the seconds reached to 0 stop the timer
          seconds =
              60; // when the timer is stopped set the timer text to 60 again
          _untoggle(); // stop the BPM estimation process when the timer reached to 0
          buttonText =
              "Check Heart Rate"; // when the timer stops change the text to Check Heart Rate because BPM process is stopped
          _save(); // here save method is called to save the BPM value when timer is over
        });
      } else {
        setState(() {
          seconds -=
              1; // here we are decreasing the seconds by 1 each time till it reach to 0
        });
      }
    });
  }

  // this is the method to save the BPM values in the text file in the external storage of your device
  _save() async {
    List list = _dateTime().split(
        " "); // here we are spiliting the string form " " which contains date and time and storing the returned list to a list
    String date = list[0].toString(); // 1st element of the list is date
    String time = list[1].toString().substring(0,
        5); // 2nd element of the list is the time from it we are only taking 1st five characters
    final directory =
        await getExternalStorageDirectory(); // this function is called to get the external storage directory
    final file = File(
        '${directory.path}/heartRate.txt'); // here we are creating a heartRate.txt file in the external storage directory
    final text = "\n" +
        date +
        " " +
        time +
        " " +
        _bpm.toString(); // here we are making a string which we will store in the text file
    await file.writeAsString(text,
        mode: FileMode
            .append); // here we are writing the string to the text file in the append mode
    print('saved');
  }

  // this is the function to get the current date and time
  String _dateTime() {
    DateTime now = new DateTime
        .now(); // this is the datetime class from where we are getting current date and time
    return now
        .toString(); // here we are returning date and time in the form of string
  }
}
