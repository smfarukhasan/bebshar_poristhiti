import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../requirement/login_screen.dart';

class CustomDrawer extends StatefulWidget {
  final String name; // User's name to be displayed
  final String mobile; // User's mobile number to be displayed
  final Function onNameEdit; // Callback for editing name
  final Function onImagePick; // Callback for picking image

  CustomDrawer({
    required this.name,
    required this.mobile,
    required this.onNameEdit,
    required this.onImagePick,
  });

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  File? _profileImage; // Variable to store selected profile image
  final ImagePicker _picker = ImagePicker(); // Image picker instance
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase authentication instance

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: GestureDetector(
              onTap: () => widget.onNameEdit(), // Edit name when tapped
              child: Text(widget.name, style: TextStyle(fontSize: 20)), // Display user's name
            ),
            accountEmail: Text(
              _auth.currentUser?.email ?? 'Email not available', // Display user's email
              style: TextStyle(fontSize: 16),
            ),
            currentAccountPicture: GestureDetector(
              onTap: () => widget.onImagePick(), // Pick profile picture when tapped
              child: CircleAvatar(
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!) // Display selected profile image
                    : const AssetImage('assets/icon/icon.png') as ImageProvider, // Default profile image
                backgroundColor: Colors.grey[200], // Background color for avatar
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.green[400], // Background color for drawer header
            ),
          ),

          // List items in the drawer for different actions
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.note_alt_outlined,
                  text: 'বাকির খাতা', // Option for note-related actions
                  onTap: () {
                    // Handle action
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.list_alt_rounded,
                  text: 'প্রোডাক্ট লিস্ট', // Option for product list
                  onTap: () {
                    // Handle action
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.add_shopping_cart,
                  text: 'ক্রয় রিপোর্ট', // Option for purchase report
                  onTap: () {
                    // Handle action
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.shopping_cart,
                  text: 'বিক্রয় রিপোর্ট', // Option for sales report
                  onTap: () {
                    // Handle action
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.payment_rounded,
                  text: 'বিল পরিশোধ', // Option for bill payments
                  onTap: () {
                    // Handle action
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.settings,
                  text: 'সেটিংস', // Option for settings
                  onTap: () {
                    // Handle action
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.logout,
                  text: 'লগ আউট', // Option for logging out
                  onTap: () async {
                    await _auth.signOut(); // Sign out the user
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen())); // Navigate to login screen
                  },
                ),
              ],
            ),
          ),

          // Add your asset image here
          Container(
            width: double.infinity,
            child: Image.asset(
              'assets/icon/icon.png', // Display logo or image in the drawer footer
              fit: BoxFit.cover,
              height: 300,
            ),
          ),
        ],
      ),
    );
  }

  // Method to build drawer list items
  ListTile _buildDrawerItem({required IconData icon, required String text, required Function onTap}) {
    return ListTile(
      leading: Icon(icon), // Icon for the list item
      title: Text(text, style: TextStyle(fontSize: 18)), // Text for the list item
      onTap: () => onTap(), // Action when the list item is tapped
    );
  }
}
