import 'package:flutter/material.dart';
import 'package:salt/View/MusicHomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //aplikasi ini membuat sendiri BloC nya tanpa plugin flutter_bloc
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MusicPage(),
    );
  }
}
