import 'package:flutter/material.dart';

class AddProducts extends StatefulWidget {
  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final _formKey = GlobalKey<FormState>();
  String _productName = '';
  String _barcode = '';
  double _purchasePrice = 0.0;
  double _salePrice = 0.0;
  int _quantity = 0;
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Products'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Product Name'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter product name';
                }
                return null;
              },
              onSaved: (value) => _productName = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Barcode'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter barcode';
                }
                return null;
              },
              onSaved: (value) => _barcode = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Purchase Price'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter purchase price';
                }
                return null;
              },
              onSaved: (value) => _purchasePrice = double.parse(value),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Sale Price'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter sale price';
                }
                return null;
              },
              onSaved: (value) => _salePrice = double.parse(value),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Quantity'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter quantity';
                }
                return null;
              },
              onSaved: (value) => _quantity = int.parse(value),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
              onSaved: (value) => _description = value,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  // Implement logic to save product
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}