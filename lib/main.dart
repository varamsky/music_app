import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music_app/providers/db_providers/fav_db_provider.dart';
import 'package:music_app/providers/db_providers/pl_list_db_provider.dart';
import 'package:music_app/providers/music_data.dart';
import 'package:music_app/screens/fav_pl_screen.dart';
import 'package:music_app/screens/home_screen.dart';
import 'package:provider/provider.dart';

//TODO: check this
/*What I learned from this project
* 1-> Using Provider State Management
* 2-> Using Audio with Flutter
* */

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MusicData>(create: (BuildContext context) => MusicData()),
        ChangeNotifierProvider<FavDbProvider>(create: (BuildContext context) => FavDbProvider()),
        ChangeNotifierProvider<PlListDbProvider>(create: (BuildContext context) => PlListDbProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Music Player App',
        home: HomeScreen(),
      ),
    );



    /*return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player App',
      home: ChangeNotifierProvider<MusicData>(
        create: (BuildContext context)=>MusicData(),
        child: HomeScreen(),
      ),
      //home: Bogus(),
      //home: MyTimer(),
    );*/
  }
}

// TODO: remove this class
class MyTimer extends StatefulWidget {
  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<MyTimer> {
  double localSliderValue = 0.0;
  int myTick;

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  void startTimer(){
    var x = Timer.periodic(Duration(seconds: 1), (Timer time){
      setState(() {
        myTick = time.tick;
        print(myTick);
        localSliderValue = myTick.toDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(myTick.toString()),
            Slider(
              value: localSliderValue,
              min: 0.0,
              max: 15.0,
              //divisions: 100,
              activeColor: Colors.green,
              inactiveColor: Colors.grey,
              onChanged: (double value) {
                setState(() {
                  localSliderValue = value;
                });
                //localSliderValue = playerData.sliderValue;
              },
            ),
          ],
        ),
      ),
    );
  }
}




//TODO: remove this class
class Bogus extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Text('BOGUS'),
    );
  }
}
