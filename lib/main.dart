import "package:flutter/material.dart";

import './pages/home.dart';

void main() => runApp(App());

class App extends StatelessWidget{

  final String title = "Changefly Animation";

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title, // title of project / app
      theme: ThemeData(
        accentColor: Color(0xFFF15E76),
        primaryColor:Color(0xFF46C4DB),
      ),
      home: Home(title)
    );
  }
}