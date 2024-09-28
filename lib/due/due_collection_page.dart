import 'package:flutter/material.dart';


class DueCollectionPage extends StatefulWidget {
  @override
  _DueCollectionPageState createState() => _DueCollectionPageState();
}

class _DueCollectionPageState extends State<DueCollectionPage> {
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
    filteredList = dueList; // Initialize filtered list with all entries
  }

  void _filterDueList(String query) {
    setState(() {
      filteredList = dueList.where((customer) {
        return customer['name'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _showDetails(int index) {
    final customer = filteredList[index];
    TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8, // Dynamic width
            height: MediaQuery.of(context).size.height * 0.65, // Increased height
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        customer['name'],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28), // Increased font size
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context), // Close dialog
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  'বাকির পরিমাণ: ${customer['amount']}৳',
                  style: TextStyle(color: Colors.red, fontSize: 26, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(customer['image'], fit: BoxFit.cover, height: 250), // Increased image size
                ),
                SizedBox(height: 50),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(
                    labelText: 'পরিমাণ লিখুন',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10), // Added space before buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 20), // Increased button height
                        ),
                        onPressed: () {
                          setState(() {
                            if (amountController.text.isNotEmpty) {
                              customer['amount'] += int.parse(amountController.text);
                            }
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          'টাকা দিলাম',
                          style: TextStyle(color: Colors.red, fontSize: 20), // Increased text size
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 20), // Increased button height
                        ),
                        onPressed: () {
                          setState(() {
                            if (amountController.text.isNotEmpty) {
                              customer['amount'] -= int.parse(amountController.text);
                            }
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          'টাকা পেলাম',
                          style: TextStyle(color: Colors.green, fontSize: 20), // Increased text size
                        ),
                      ),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('বাকি আদায়'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // সার্চ বক্স
            TextField(
              controller: _searchController,
              onChanged: _filterDueList,
              decoration: InputDecoration(
                labelText: 'সার্চ করুন',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 10),
            // কাস্টমার লিস্ট
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final customer = filteredList[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          customer['image'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(customer['name'],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        '${customer['amount']}৳',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      onTap: () => _showDetails(index), // Show details on tap
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
