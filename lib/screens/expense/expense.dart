import 'package:flutter/material.dart';

class Expense extends StatefulWidget {
  @override
  _ExpenseState createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  final _formKey = GlobalKey<FormState>();
  String _expenseName = '';
  double _amount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Expense Name'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter expense name';
                }
                return null;
              },
              onSaved: (value) => _expenseName = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Amount'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter amount';
                }
                return null;
              },
              onSaved: (value) => _amount = double.parse(value),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  // Implement logic to save expense
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}