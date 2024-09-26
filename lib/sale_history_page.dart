import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_customer_page.dart';

// Assuming the saleHistory list is globally available

class SaleHistoryPage extends StatefulWidget {
  @override
  _SaleHistoryPageState createState() => _SaleHistoryPageState();
}

class _SaleHistoryPageState extends State<SaleHistoryPage> {
  String _searchQuery = '';
  List<Map<String, dynamic>> _filteredSales = [];
  double _totalDailySales = 0.0; // Variable to store daily sales
  Timer? _resetTimer; // Timer to reset the daily sales
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  double _totalSelectedSales = 0.0; // Variable for selected date range sales

  @override
  void initState() {
    super.initState();
    _filteredSales = saleHistory;
    _calculateDailySales();
    _scheduleDailyReset();
  }

  void _calculateDailySales() {
    final today = DateTime.now();
    _totalDailySales = saleHistory
        .where((sale) =>
            sale['saleDate'].day == today.day &&
            sale['saleDate'].month == today.month &&
            sale['saleDate'].year == today.year)
        .fold(0.0, (sum, sale) => sum + sale['totalAmount']);
  }

  void _scheduleDailyReset() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = midnight.difference(now);

    _resetTimer = Timer(durationUntilMidnight, () {
      setState(() {
        _totalDailySales = 0.0;
      });
      _scheduleDailyReset();
    });
  }

  void _searchSales(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredSales = saleHistory
          .where((sale) => sale['name'].toLowerCase().contains(_searchQuery))
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

      _calculateSelectedSales();
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

  void _calculateSelectedSales() {
    if (_selectedStartDate != null && _selectedEndDate != null) {
      _totalSelectedSales = saleHistory
          .where((sale) =>
              sale['saleDate']
                  .isAfter(_selectedStartDate!.subtract(Duration(days: 1))) &&
              sale['saleDate']
                  .isBefore(_selectedEndDate!.add(Duration(days: 1))))
          .fold(0.0, (sum, sale) => sum + sale['totalAmount']);
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
        title: Text('সকল বিক্রয়সমূহ'),
      ),
      body: Column(
        children: [
          // Daily total sales box
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amberAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'আজকের মোট বিক্রয়: ৳${_totalDailySales.toStringAsFixed(2)}',
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
                    'নির্বাচিত তারিখের মোট বিক্রয়: ৳${_totalSelectedSales.toStringAsFixed(2)}',
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
                labelText: 'ক্রেতার নাম দিয়ে সার্চ করুন',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => _searchSales(value),
            ),
          ),

          Expanded(
            child: _filteredSales.isEmpty
                ? Center(
                    child: Text('কোন তথ্য পাওয়া যায় নি'),
                  )
                : ListView.builder(
                    itemCount: _filteredSales.length,
                    itemBuilder: (context, index) {
                      final customer = _filteredSales[index];
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ক্রেতা: ${customer['name']}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'তারিখ: ${DateFormat('dd-MM-yyyy').format(customer['saleDate'])}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'সর্বমোট মূল্য: ৳${customer['totalAmount'].toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'প্রোডাক্ট:',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              for (var product in customer['products'])
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
