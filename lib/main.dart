import 'package:flutter/material.dart';
import 'package:note_keeper_flutter/Pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Note Keeper",
      theme: ThemeData(
        primarySwatch: Colors.cyan
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
