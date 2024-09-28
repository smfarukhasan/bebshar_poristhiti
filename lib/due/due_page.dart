import 'package:flutter/material.dart';
import 'due_collection_page.dart'; // বাকির আদায় পেজ
import 'package:image_picker/image_picker.dart'; // ছবি পরিবর্তনের জন্য

class DuePage extends StatefulWidget {
  @override
  _DuePageState createState() => _DuePageState();
}

class _DuePageState extends State<DuePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> dueList = [
    {'name': 'John Doe', 'amount': 5000, 'image': 'assets/error.jpg'},
    {'name': 'Jane Smith', 'amount': 3000, 'image': 'assets/error.jpg'},
    // আরও এন্ট্রি যুক্ত করা যাবে
  ];

  List<Map<String, dynamic>> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = dueList;
  }

  void _filterDueList(String query) {
    setState(() {
      filteredList = dueList.where((customer) {
        return customer['name'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _editDue(int index) {
    final customer = filteredList[index];
    final TextEditingController nameController = TextEditingController(text: customer['name']);
    final TextEditingController amountController = TextEditingController(text: customer['amount'].toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('এডিট করুন'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'নাম'),
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'বাকি পরিমাণ'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  dueList[filteredList.indexOf(customer)] = {
                    'name': nameController.text,
                    'amount': int.parse(amountController.text),
                    'image': customer['image'],
                  };
                  _filterDueList(_searchController.text); // Update filtered list
                });
                Navigator.pop(context);
              },
              child: Text('আপডেট'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(int index) async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        filteredList[index]['image'] = pickedFile.path; // Update image path
        dueList[filteredList.indexOf(filteredList[index])]['image'] = pickedFile.path; // Update original list
      });
    }
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
                        _pickImage(filteredList.indexWhere((customer) => customer['image'] == imagePath)); // Image edit action
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('বাকির খাতা'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.lightGreen, // Button color
              foregroundColor: Colors.white, // Text color
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
            // সার্চ বক্স
            TextField(
              controller: _searchController,
              onChanged: _filterDueList,
              decoration: InputDecoration(
                labelText: 'সার্চ করুন',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 10),
            // বাকির লিস্ট
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final customer = filteredList[index];
                  return Card(
                    child: ListTile(
                      leading: GestureDetector(
                        onTap: () => _showImage(context, customer['image']),
                        child: Image.asset(
                          customer['image'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(customer['name'], style: TextStyle(fontSize: screenWidth * 0.05)),
                      trailing: Text(
                        '${customer['amount']}৳',
                        style: TextStyle(color: Colors.red, fontSize: screenWidth * 0.05),
                      ),
                      onTap: () {
                        _editDue(index); // Edit on tap
                      },
                      onLongPress: () => _pickImage(index), // Long press to change image
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
