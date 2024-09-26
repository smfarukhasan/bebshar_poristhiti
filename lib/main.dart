// lib/main.dart
import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import HomeScreen

void main() {
  runApp(bebshar_poristhiti());
}

class bebshar_poristhiti extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'bebshar_poristhiti',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeScreen(), // Set HomeScreen as the initial screen
    );
  }
}
