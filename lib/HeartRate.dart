import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HeartRate extends StatefulWidget {
  HeartRate({Key key}) : super(key: key);

  @override
  _HeartRateState createState() => _HeartRateState();
}

class _HeartRateState extends State<HeartRate> {
  // fucntion to read the text file and return the content in a list
  Future<List<List>> _read() async {
    final directory =
        await getExternalStorageDirectory(); // calling a function to get the external storage directory
    final file = File(
        '${directory.path}/heartRate.txt'); // checking if the file is present or not, id present the get the location
    List list = [];
    // try catch block to catch the exception which is thrown when empty list is returned
    try {
      list = await file
          .readAsLines(); // reading the file and returning the contents in the form of list
    } catch (e) {
      print(e);
    }
    List<List> lists =
        []; //created a list of list to store the individual values for heartrate, time and date
    for (int i = 1; i < list.length; i++) {
      lists.add(list[i].toString().split(
          " ")); // here we are adding individual values of heartrate, time and date to lists
    }
    return lists; // returning lists where data is present
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Heart Rate Values",
        ),
      ),
      body: FutureBuilder<List<List>>(
        future:
            _read(), // this is the function which will return data to us in future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //to check if we got the data properly or not
            if (snapshot.data.length == 0) {
              // if the data returned to us is the empty list
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset('assets/nofile.png'),
                  Text(
                    "No data to show",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                ],
              ));
            } else {
              // or if the list has the values
              return Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.blue[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          title: Text(
                              "BPM : " + snapshot.data[index][2].toString()),
                          subtitle: Text("Date: " +
                              snapshot.data[index][0].toString() +
                              " " +
                              "Time: " +
                              snapshot.data[index][1].toString()),
                        ),
                      );
                    },
                  ),
                ),
              );
            }
          } else if (snapshot.hasError) {
            // if the data returned has some error
            throw snapshot.error;
          } else {
            // if the data is not retured, till then show the circularprogrssindicator
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
