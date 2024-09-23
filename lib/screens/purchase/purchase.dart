import 'package:flutter/material.dart';

class Purchase extends StatefulWidget {
  @override
  _PurchaseState createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  final _formKey = GlobalKey<FormState>();
  DateTime _date = DateTime.now();
  String _supplierName = '';
  double _totalPrice = 0.0;
  double _previousDue = 0.0;
  double _paidAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Supplier Name'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter supplier name';
                }
                return null;
              },
              onSaved: (value) => _supplierName = value,
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
                  // Implement logic to save purchase
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}