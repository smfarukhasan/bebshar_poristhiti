import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _shopName = '';
  String _phoneNumber = '';
  String _emailAddress = '';
  String _address = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter name';
                }
                return null;
              },
              onSaved: (value) => _name = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Shop Name'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter shop name';
                }
                return null;
              },
              onSaved: (value) => _shopName = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Phone Number'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter phone number';
                }
                return null;
              },
              onSaved: (value) => _phoneNumber = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email Address'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter email address';
                }
                return null;
              },
              onSaved: (value) => _emailAddress = value,
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
                  // Implement logic to save user profile
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}