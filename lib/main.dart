import 'package:flutter/material.dart';
import 'package:music_app/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player App',
      home: HomeScreen(),
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
