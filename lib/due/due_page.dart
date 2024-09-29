import 'package:flutter/material.dart';
import '../sales_management/customer_page.dart';
import 'due_collection_page.dart'; // বাকির আদায় পেজ
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart'; // ছবি পরিবর্তনের জন্য

class DuePage extends StatefulWidget {
  @override
  _DuePageState createState() => _DuePageState();
}

class _DuePageState extends State<DuePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  void _filterDueList(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('বাকির খাতা'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCustomerPage()), // নতুন কাস্টমার পেজ
              );
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.lightGreen,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DueCollectionPage()), // বাকির আদায় পেজ
              );
            },
            child: Text('বাকি আদায়'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 10),
            _buildCustomerList(screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: _filterDueList,
      decoration: InputDecoration(
        labelText: 'সার্চ করুন',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _buildCustomerList(double screenWidth) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('customers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final customers = snapshot.data!.docs.where((doc) {
            final customerName = doc['name'].toString().toLowerCase();
            return customerName.contains(_searchQuery);
          }).toList();

          if (customers.isEmpty) {
            return Center(child: Text('কোনো কাস্টমার পাওয়া যায়নি'));
          }

          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index];
              return _buildCustomerCard(customer, screenWidth);
            },
          );
        },
      ),
    );
  }

  Widget _buildCustomerCard(QueryDocumentSnapshot customer, double screenWidth) {
    // `customer.data()` কে `Map<String, dynamic>` এ কাস্ট করুন
    final customerData = customer.data() as Map<String, dynamic>;

    return Card(
      child: ListTile(
        leading: GestureDetector(
          onTap: () => _showImage(
            context,
            customerData['image'] ?? 'assets/error.jpg', // Default image if null
          ),
          child: _buildCustomerImage(
            customerData['image'] ?? 'assets/error.jpg', // Default image if null
          ),
        ),
        title: Text(
          customerData['name'] ?? 'নাম নেই', // Default text if null
          style: TextStyle(fontSize: screenWidth * 0.05),
        ),
        trailing: Text(
          customerData['amount'] != null && customerData['amount'] is String
              ? '${customerData['amount']}৳'
              : 'নেই', // Show 'নেই' if amount is null or not a string
          style: TextStyle(color: Colors.red, fontSize: screenWidth * 0.05),
        ),
      ),
    );
  }

  Widget _buildCustomerImage(String imagePath) {
    return Image.asset(
      imagePath,
      width: 60,
      height: 60,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/error.jpg', // Default error image
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        );
      },
    );
  }

  void _showImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            constraints: BoxConstraints(maxWidth: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(imagePath, fit: BoxFit.cover, height: 300),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _pickImage(imagePath); // Image edit action
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(String customerId) async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Firestore বা Firebase Storage এ ছবিটি আপলোড করুন
      await FirebaseFirestore.instance.collection('customers').doc(customerId).update({
        'image': pickedFile.path, // নতুন ছবি URL
      });
    }
  }
}
