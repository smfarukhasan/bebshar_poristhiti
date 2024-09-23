import 'package:flutter/material.dart';
import 'package:bebshar_poristhiti/drawer/drawer_header.dart';
import 'package:bebshar_poristhiti/drawer/drawer_list.dart';
import 'package:bebshar_poristhiti/screens/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bebshar Poristhiti',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bebshar Poristhiti'),
        leading: DrawerHeader(),
      ),
      body: Center(
        child: Text('Home Page'),
      ),
      drawer: DrawerList(),
    );
  }
}