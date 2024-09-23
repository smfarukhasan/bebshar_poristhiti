import 'package:flutter/material.dart';

class Cash extends StatefulWidget {
  @override
  _CashState createState() => _CashState();
}

class _CashState extends State<Cash> {
  double _totalCash = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cash Box'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Total Cash: $_totalCash'),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Add Cash'),
              onPressed: () {
                // Implement logic to add cash
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Remove Cash'),
              onPressed: () {
                // Implement logic to remove cash
              },
            ),
          ],
        ),
      ),
    );
  }
}