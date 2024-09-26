import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_supplier_page.dart';

// Assuming the PurchaseHistory list is globally available

class PurchaseHistoryPage extends StatefulWidget {
  @override
  _PurchaseHistoryPageState createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  String _searchQuery = '';
  List<Map<String, dynamic>> _filteredPurchases = [];
  double _totalDailyPurchases = 0.0; // Variable to store daily Purchases
  Timer? _resetTimer; // Timer to reset the daily Purchases
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  double _totalSelectedPurchases =
  0.0; // Variable for selected date range Purchases

  @override
  void initState() {
    super.initState();
    _filteredPurchases = purchaseHistory;
    _calculateDailyPurchases();
    _scheduleDailyReset();
  }

  void _calculateDailyPurchases() {
    final today = DateTime.now();
    _totalDailyPurchases = purchaseHistory
        .where((purchase) =>
    purchase['purchaseDate'] != null && // Add null check
        purchase['purchaseDate'].day == today.day &&
        purchase['purchaseDate'].month == today.month &&
        purchase['purchaseDate'].year == today.year)
        .fold(0.0, (sum, purchase) => sum + purchase['totalAmount']);
  }

  void _scheduleDailyReset() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = midnight.difference(now);

    _resetTimer = Timer(durationUntilMidnight, () {
      setState(() {
        _totalDailyPurchases = 0.0;
      });
      _scheduleDailyReset();
    });
  }

  void _searchPurchases(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredPurchases = purchaseHistory
          .where((purchase) =>
      purchase['name'] != null &&
          purchase['name'].toLowerCase().contains(_searchQuery))
          .toList();
    });
  }

  void _selectDateRange() async {
    DateTime? endDate = await _selectDate(context);
    if (endDate == null) return;

    DateTime? startDate = await _selectDate(context);
    if (startDate == null) return;

    setState(() {
      _selectedEndDate = endDate;
      _selectedStartDate = startDate;

      _calculateSelectedPurchases();
    });
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
  }

  void _calculateSelectedPurchases() {
    if (_selectedStartDate != null && _selectedEndDate != null) {
      _totalSelectedPurchases = purchaseHistory
          .where((purchase) =>
      purchase['purchaseDate'] != null && // Add null check
          purchase['purchaseDate']
              .isAfter(_selectedStartDate!.subtract(Duration(days: 1))) &&
          purchase['purchaseDate']
              .isBefore(_selectedEndDate!.add(Duration(days: 1))))
          .fold(0.0, (sum, purchase) => sum + purchase['totalAmount']);
    }
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('সকল ক্রয়সমূহ'),
      ),
      body: Column(
        children: [
          // Daily total Purchases box
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amberAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'আজকের মোট ক্রয়: ৳${_totalDailyPurchases.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Date range selection box
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'নির্বাচিত তারিখ: ${_selectedStartDate != null ? DateFormat('dd-MM-yyyy').format(_selectedStartDate!) : 'না'} - ${_selectedEndDate != null ? DateFormat('dd-MM-yyyy').format(_selectedEndDate!) : 'না'}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _selectDateRange,
                    child: Text('তারিখ নির্বাচন করুন'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'নির্বাচিত তারিখের মোট ক্রয়: ৳${_totalSelectedPurchases.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'সাপ্লায়ারের নাম দিয়ে সার্চ করুন',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => _searchPurchases(value),
            ),
          ),

          Expanded(
            child: _filteredPurchases.isEmpty
                ? Center(
              child: Text('কোন তথ্য পাওয়া যায় নি'),
            )
                : ListView.builder(
              itemCount: _filteredPurchases.length,
              itemBuilder: (context, index) {
                final supplier = _filteredPurchases[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'সাপ্লায়ার: ${supplier['name']}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          supplier['purchaseDate'] != null
                              ? 'তারিখ: ${DateFormat('dd-MM-yyyy').format(supplier['purchaseDate'])}'
                              : 'তারিখ: না',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'সর্বমোট মূল্য: ৳${supplier['totalAmount'].toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'প্রোডাক্ট:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        for (var product in supplier['products'])
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              '${product['productName']} - ৳${product['productPrice'].toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
