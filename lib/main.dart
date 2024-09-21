import 'package:flutter/material.dart';
import 'package:nusantara/Mapss.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Map with Location Marker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LocationMapPage(),
    );
  }
}

