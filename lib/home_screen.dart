import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bebshar_poristhiti/personal_expense.dart';
import 'add_customer_page.dart';
import 'app_payment.dart';
import 'product_page.dart';
import 'sale_history_page.dart';
import 'add_supplier_page.dart';
import 'purchase_history_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'stock_management_page.dart';
import 'contact_management_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _name = "Name";
  String _mobile = "০১৫৫৮৯৯৩৩৪১";
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width; // Get screen width
    var screenHeight = MediaQuery.of(context).size.height; // Get screen height

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 158, 255),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'দোকানের নাম',
              style: TextStyle(color: Colors.black, fontSize: screenWidth * 0.05), // Font size based on screen width
            ),
            Text(
              'ব্যবসার পরিস্থিতি',
              style: TextStyle(color: Colors.black54, fontSize: screenWidth * 0.035),
            ),
          ],
        ),
        actions: [
          Icon(Icons.notifications, color: Colors.black, size: screenWidth * 0.07),
          SizedBox(width: screenWidth * 0.03),
        ],
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLargeActionButtons(context, screenWidth, screenHeight), // Replaced the Date and Backup section
            SizedBox(height: screenHeight * 0.02),
            _buildSummaryCardSection(screenWidth),
            SizedBox(height: screenHeight * 0.02),
            _buildActionGrid(context, screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.02),
            _buildSupportSection(screenWidth),
          ],
        ),
      ),
    );
  }

  // Drawer widget with editable profile information
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: GestureDetector(
              onTap: () {
                _showEditNameDialog();
              },
              child: Text(_name, style: TextStyle(fontSize: 20)),
            ),
            accountEmail: Text('মোবাইলঃ $_mobile', style: TextStyle(fontSize: 16)),
            currentAccountPicture: GestureDetector(
              onTap: () {
                _pickImage();
              },
              child: CircleAvatar(
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!) as ImageProvider
                    : const AssetImage('assets/profile_picture.png'),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.green[400],
            ),
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('পাসওয়ার্ড পরিবর্তন', style: TextStyle(fontSize: 18)),
            onTap: () {
              // Handle password change action
            },
          ),
          ListTile(
            leading: Icon(Icons.refresh),
            title: Text('পাসওয়ার্ড রিসেট', style: TextStyle(fontSize: 18)),
            onTap: () {
              // Handle password reset action
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('লগ আউট', style: TextStyle(fontSize: 18)),
            onTap: () {
              // Handle log out action
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _showEditNameDialog() {
    final TextEditingController nameController =
    TextEditingController(text: _name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('নাম পরিবর্তন করুন', style: TextStyle(fontSize: 20)),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: "নতুন নাম লিখুন"),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('সংরক্ষণ করুন'),
              onPressed: () {
                setState(() {
                  _name = nameController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Section 1: Large Action Buttons for 'ক্রয়' and 'বিক্রয়'
  Widget _buildLargeActionButtons(
      BuildContext context, double screenWidth, double screenHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLargeActionButton(Icons.shopping_cart, 'ক্রয়', context, Colors.brown, screenWidth, screenHeight),
        _buildLargeActionButton(Icons.shopping_bag, 'বিক্রয়', context, Colors.indigo, screenWidth, screenHeight),
      ],
    );
  }

  Widget _buildLargeActionButton(IconData icon, String label, BuildContext context, Color color,
      double screenWidth, double screenHeight) {
    // Define custom background colors for 'ক্রয়' and 'বিক্রয়'
    Color backgroundColor = (label == 'ক্রয়') ? Colors.brown[100]! : Colors.indigo[100]!;

    return Expanded(
      child: InkWell(
        onTap: () {
          if (label == 'ক্রয়') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddSuppliersPage()),
            );
          } else if (label == 'বিক্রয়') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddCustomersPage()),
            );
          }
        },
        child: Card(
          color: backgroundColor, // Set background color dynamically
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
            child: Column(
              children: [
                Icon(icon, size: screenWidth * 0.15, color: color),
                SizedBox(height: screenHeight * 0.01),
                Text(label, style: TextStyle(fontSize: screenWidth * 0.05, color: color)),
              ],
            ),
          ),
        ),
      ),
    );
  }


  // Section 2: Summary Card Section
  Widget _buildSummaryCardSection(double screenWidth) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem('দৈনিক ক্রয়', '৳ 0', true, screenWidth),
                _buildSummaryItem('দৈনিক বাকি', '৳ 0', false, screenWidth),
                _buildSummaryItem('দৈনিক বিক্রি', '৳ 0', false, screenWidth),
              ],
            ),
            Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem('মোট বাকির পরিমাণ', '৳ 000', false, screenWidth),
                ElevatedButton(
                    onPressed: () {},
                    child: Text('বাকি আদায়',
                        style: TextStyle(fontSize: screenWidth * 0.04))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
      String title, String value, bool isPrimary, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: screenWidth * 0.045,
              color: isPrimary ? Colors.black : Colors.black54),
        ),
        SizedBox(height: screenWidth * 0.02),
        Text(
          value,
          style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
              color: isPrimary ? Colors.blue : Colors.black),
        ),
      ],
    );
  }

  // Section 3: Action Grid Section
  Widget _buildActionGrid(
      BuildContext context, double screenWidth, double screenHeight) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 4,
      crossAxisSpacing: screenWidth * 0.02,
      mainAxisSpacing: screenHeight * 0.02,
      children: [
        _buildActionButton(Icons.shelves, 'ক্রয় সমূহ', context, Colors.brown, screenWidth),
        _buildActionButton(Icons.shopping_cart_checkout, 'বিক্রয় সমূহ', context, Colors.indigo, screenWidth),
        _buildActionButton(Icons.store, 'স্টক', context, Colors.teal, screenWidth),
        _buildActionButton(Icons.people, 'সকল পার্টি', context, Colors.pink, screenWidth),
        _buildActionButton(Icons.report, 'বিক্রয় রিপোর্ট', context, Colors.amber, screenWidth),
        _buildActionButton(Icons.pie_chart, 'ক্রয় রিপোর্ট', context, Colors.blue, screenWidth),
        _buildActionButton(Icons.credit_card, 'খরচের হিসাব', context, Colors.deepPurple, screenWidth),
        _buildActionButton(Icons.money_rounded, 'প্রোডাক্ট লিস্ট', context, Colors.cyan, screenWidth),
        _buildActionButton(Icons.history, 'বিল পরিশোধ', context, Colors.green, screenWidth), // New 'ক্রয়সমূহ' button
        _buildActionButton(Icons.settings, 'সেটিংস', context, Colors.grey, screenWidth),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, BuildContext context,
      Color color, double screenWidth) {
    double iconSize = screenWidth * 0.08; // Dynamically calculate icon size
    double radius = screenWidth * 0.075; // Dynamically calculate radius
    double fontSize = screenWidth * 0.035; // Dynamically calculate font size

    return InkWell(
      onTap: () {
        if (label == 'বিক্রয় সমূহ') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SaleHistoryPage()),
          );
        } else if (label == 'ক্রয় সমূহ') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PurchaseHistoryPage()), // Navigate to Purchase History Page
          );
        } else if (label == 'প্রোডাক্ট লিস্ট') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductPage()),
          );
        } else if (label == 'স্টক') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StockManagementPage()),
          );
        } else if (label == 'সকল পার্টি') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContactManagementPage()),
          );
        } else if (label == 'খরচের হিসাব') {   //personal expense
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PersonalExpensePage()),
          );
        } else if (label == 'বিল পরিশোধ') {   //personal expense
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AppPaymentPage()),
          );
        }


      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            elevation: 5,
            shape: CircleBorder(),
            color: color.withOpacity(0.2),
            child: CircleAvatar(
              backgroundColor: color.withOpacity(0.5),
              radius: radius, // Dynamic radius
              child: Icon(icon, size: iconSize, color: Colors.white), // Dynamic icon size
            ),
          ),
          SizedBox(height: screenWidth * 0.02), // Adjust spacing dynamically
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: fontSize), // Dynamic font size
            ),
          ),
        ],
      ),
    );
  }

  // Section 4: Support Section
  Widget _buildSupportSection(double screenWidth) {
    return Column(
      children: [
        Card(
          color: Colors.blue[100],
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: Icon(Icons.add_call, color: Colors.blue),
            title: Text(
              'সাহায্যের জন্য ফোন করুন',
              style: TextStyle(fontSize: screenWidth * 0.05),
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: screenWidth * 0.05),
            onTap: () {
              // Handle support action
            },
          ),
        ),
        SizedBox(height: screenWidth * 0.05),
      ],
    );
  }
}
