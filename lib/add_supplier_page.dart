import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

// Global list to store purchase histories
List<Map<String, dynamic>> purchaseHistory = [];

class AddSuppliersPage extends StatefulWidget {
  @override
  _AddSuppliersPageState createState() => _AddSuppliersPageState();
}

class _AddSuppliersPageState extends State<AddSuppliersPage> {
  final _formKey = GlobalKey<FormState>();

  // Single customer with a list of products
  Map<String, dynamic> _supplier = {
    "name": "",
    "products": [
      {"productName": "", "productPrice": 0.0}
    ],
    "purchaseDate": DateTime.now(),
    "totalAmount": 0.0,
  };

  // Function to calculate the total purchase amount from product prices
  void _calculateTotalAmount() {
    double total = 0.0;
    for (var product in _supplier['products']) {
      total += product['productPrice'];
    }
    setState(() {
      _supplier['totalAmount'] = total;
    });
  }

  // Function to add a new product entry
  void _addProduct() {
    setState(() {
      _supplier['products'].add({"productName": "", "productPrice": 0.0});
    });
  }

  // Function to remove a product entry
  void _removeProduct(int productIndex) {
    setState(() {
      _supplier['products'].removeAt(productIndex);
      _calculateTotalAmount(); // Recalculate after removing a product
    });
  }

  // Function to pick a date for the purchase
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _supplier['purchaseDate'],
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _supplier['purchaseDate']) {
      setState(() {
        _supplier['purchaseDate'] = picked;
      });
    }
  }

  // Function to save and submit the form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Save customer purchase to the global history list
      purchaseHistory.add(Map.from(_supplier));
      // Navigate back or show a success message
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('নতুন ক্রয়'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Customer name
              TextFormField(
                decoration: InputDecoration(labelText: 'সাপ্লায়ারের নাম'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'সাপ্লায়ারের নাম লিখুন';
                  }
                  return null;
                },
                onSaved: (value) {
                  _supplier['name'] = value!;
                },
              ),
              SizedBox(height: 10),

              // Date picker for purchase date
              Row(
                children: [
                  Text('ক্রয়ের তারিখ: '),
                  Text(
                    DateFormat('dd-MM-yyyy').format(_supplier['purchaseDate']),
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
                  itemCount: _supplier['products'].length,
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
                              _supplier['products'][productIndex]
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
                                _supplier['products'][productIndex]
                                        ['productPrice'] =
                                    double.tryParse(value) ?? 0.0;
                              });
                              _calculateTotalAmount();
                            },
                            onSaved: (value) {
                              _supplier['products'][productIndex]
                                  ['productPrice'] = double.parse(value!);
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_circle),
                          onPressed: () {
                            if (_supplier['products'].length > 1) {
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
                'সর্বমোট মূল্য: ৳${_supplier['totalAmount'].toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              // Submit button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,   // Background color
                  foregroundColor: Colors.white,  // Text color
                ),
                child: Text('ক্রয় করুন'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
