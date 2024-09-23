import 'package:flutter/material.dart';

class Supplier extends StatefulWidget {
  @override
  _SupplierState createState() => _SupplierState();
}

class _SupplierState extends State<Supplier> {
  final _formKey = GlobalKey<FormState>();
  String _supplierName = '';
  String _phone_number = '';
  String _address = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supplier'),
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
              decoration: InputDecoration (labelText: 'Phone Number'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter phone number';
                }
                return null;
              },
              onSaved: (value) => _phone_number = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Address'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter address';
                }
                return null;
              },
              onSaved: (value) => _address = value,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  // Implement logic to save supplier
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}