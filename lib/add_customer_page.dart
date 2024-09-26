import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

// Global list to store purchase histories
List<Map<String, dynamic>> saleHistory = [];

class AddCustomersPage extends StatefulWidget {
  @override
  _AddCustomersPageState createState() => _AddCustomersPageState();
}

class _AddCustomersPageState extends State<AddCustomersPage> {
  final _formKey = GlobalKey<FormState>();

  // Single customer with a list of products
  Map<String, dynamic> _customer = {
    "name": "",
    "products": [
      {"productName": "", "productPrice": 0.0}
    ],
    "saleDate": DateTime.now(),
    "totalAmount": 0.0,
  };

  // Function to calculate the total purchase amount from product prices
  void _calculateTotalAmount() {
    double total = 0.0;
    for (var product in _customer['products']) {
      total += product['productPrice'];
    }
    setState(() {
      _customer['totalAmount'] = total;
    });
  }

  // Function to add a new product entry
  void _addProduct() {
    setState(() {
      _customer['products'].add({"productName": "", "productPrice": 0.0});
    });
  }

  // Function to remove a product entry
  void _removeProduct(int productIndex) {
    setState(() {
      _customer['products'].removeAt(productIndex);
      _calculateTotalAmount(); // Recalculate after removing a product
    });
  }

  // Function to pick a date for the purchase
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _customer['saleDate'],
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _customer['saleDate']) {
      setState(() {
        _customer['saleDate'] = picked;
      });
    }
  }

  // Function to save and submit the form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Save customer purchase to the global history list
      saleHistory.add(Map.from(_customer));
      // Navigate back or show a success message
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('নতুন বিক্রয়'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Customer name
              TextFormField(
                decoration: InputDecoration(labelText: 'ক্রেতার নাম'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ক্রেতার নাম লিখুন';
                  }
                  return null;
                },
                onSaved: (value) {
                  _customer['name'] = value!;
                },
              ),
              SizedBox(height: 10),

              // Date picker for purchase date
              Row(
                children: [
                  Text('বিক্রয়ের তারিখ: '),
                  Text(
                    DateFormat('dd-MM-yyyy').format(_customer['saleDate']),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Products section
              Expanded(
                child: ListView.builder(
                  itemCount: _customer['products'].length,
                  itemBuilder: (context, productIndex) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText:
                                    'প্রোডাক্টের নাম ${productIndex + 1}'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'প্রোডাক্টের নাম লিখুন';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _customer['products'][productIndex]
                                  ['productName'] = value!;
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'মূল্য'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null ||
                                  double.tryParse(value) == null) {
                                return 'সংখ্যায় মূল্য লিখুন';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              // Update product price on change and recalculate total
                              setState(() {
                                _customer['products'][productIndex]
                                        ['productPrice'] =
                                    double.tryParse(value) ?? 0.0;
                              });
                              _calculateTotalAmount();
                            },
                            onSaved: (value) {
                              _customer['products'][productIndex]
                                  ['productPrice'] = double.parse(value!);
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_circle),
                          onPressed: () {
                            if (_customer['products'].length > 1) {
                              _removeProduct(productIndex);
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 16),

              // Add product button
              ElevatedButton(
                onPressed: _addProduct,
                child: Text('প্রোডাক্ট যোগ করুন'),
              ),
              SizedBox(height: 16),

              // Display the total purchase amount
              Text(
                'সর্বমোট মূল্য: ৳${_customer['totalAmount'].toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              // Submit button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,   // Background color
                  foregroundColor: Colors.white,   // Text color
                ),
                child: Text('বিক্রয় করুন'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
