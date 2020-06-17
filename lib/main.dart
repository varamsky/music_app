import 'package:flutter/material.dart';
import 'package:music_app/model/music_data.dart';
import 'package:music_app/screens/home_screen.dart';
import 'package:provider/provider.dart';

//TODO: check this
/*What I learned from this project
* 1-> Using Providers
* 2-> Using Audio with Flutter
* */

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player App',
      home: ChangeNotifierProvider<MusicData>(
        create: (BuildContext context)=>MusicData(),
        child: HomeScreen(),
      ),
      //home: Bogus(),
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
