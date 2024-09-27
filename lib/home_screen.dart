import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets/large_action_buttons.dart';
import 'widgets/summary_card_section.dart';
import 'widgets/action_grid.dart';
import 'widgets/support_section.dart';
import 'widgets/custom_drawer.dart';
import 'widgets/edit_name_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _name = "Name"; // User's name for profile (default value)
  String _mobile = "phone number"; // User's phone number (default value)
  File? _profileImage; // File to hold selected profile image
  final ImagePicker _picker = ImagePicker(); // For image picking from gallery
  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuth instance to handle authentication

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width; // Get screen width for responsive layout
    var screenHeight = MediaQuery.of(context).size.height; // Get screen height for responsive layout

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 158, 255), // Set app bar color
        elevation: 0, // Remove shadow
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'দোকানের নাম',
              style: TextStyle(color: Colors.black, fontSize: screenWidth * 0.05), // Shop name text style
            ),
            Text(
              'ব্যবসার পরিস্থিতি',
              style: TextStyle(color: Colors.black54, fontSize: screenWidth * 0.035), // Business status text style
            ),
          ],
        ),
        actions: [
          Icon(Icons.notifications, color: Colors.black, size: screenWidth * 0.07), // Notification icon
          SizedBox(width: screenWidth * 0.03), // Space between the icon and the edge
        ],
      ),
      drawer: CustomDrawer(
        name: _name,
        mobile: _mobile,
        onNameEdit: _showEditNameDialog, // Callback for editing name
        onImagePick: _pickImage, // Callback for picking image
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Padding for body content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LargeActionButtons(context, screenWidth, screenHeight), // Large buttons for primary actions
            SizedBox(height: screenHeight * 0.02), // Space between sections
            SummaryCardSection(screenWidth), // Display summary information
            SizedBox(height: screenHeight * 0.02), // Space between sections
            ActionGrid(context, screenWidth, screenHeight), // Grid layout for various actions
            SizedBox(height: screenHeight * 0.02), // Space between sections
            SupportSection(screenWidth), // Section for support information
          ],
        ),
      ),
    );
  }

  // Method to pick profile image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery); // Opens gallery for image selection
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path); // Updates profile image state
      });
    }
  }

  // Method to show edit name dialog
  void _showEditNameDialog() {
    final TextEditingController nameController = TextEditingController(text: _name); // Initialize controller with current name
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditNameDialog(
          controller: nameController, // Pass the controller to the dialog
          onSave: () {
            setState(() {
              _name = nameController.text; // Update the name after save
            });
          },
        );
      },
    );
  }
}
