import 'package:flutter/material.dart';

class Sale extends StatefulWidget {
  @override
  _SaleState createState() => _SaleState();
}

class _SaleState extends State<Sale> {
  final _formKey = GlobalKey<FormState>();
  DateTime _date = DateTime.now();
  String _customerName = '';
  double _totalPrice = 0.0;
  double _previousDue = 0.0;
  double _paidAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sale'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Customer Name'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter customer name';
                }
                return null;
              },
              onSaved: (value) => _customerName = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Total Price'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter total price';
                }
                return null;
              },
              onSaved: (value) => _totalPrice = double.parse(value),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Previous Due'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter previous due';
                }
                return null;
              },
              onSaved: (value) => _previousDue = double.parse(value),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Paid Amount'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter paid amount';
                }
                return null;
              },
              onSaved: (value) => _paidAmount = double.parse(value),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  // Implement logic to save sale
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}