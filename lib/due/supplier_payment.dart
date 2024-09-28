import 'package:flutter/material.dart';

class SupplierPaymentPage extends StatefulWidget {
  @override
  _SupplierPaymentPageState createState() => _SupplierPaymentPageState();
}

class _SupplierPaymentPageState extends State<SupplierPaymentPage> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> supplierList = [
    {'name': 'Supplier 1', 'balance': 10000, 'image': 'assets/error.jpg'},
    {'name': 'Supplier 2', 'balance': 20000, 'image': 'assets/error.jpg'},
  ];
  List<Map<String, dynamic>> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = supplierList;
  }

  void _filterSupplierList(String query) {
    setState(() {
      filteredList = supplierList
          .where((supplier) => supplier['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showDetails(int index) {
    final supplier = filteredList[index];
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(supplier['name'], textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  ),
                  IconButton(icon: Icon(Icons.close, color: Colors.redAccent), onPressed: () => Navigator.pop(context)),
                ],
              ),
              SizedBox(height: 10),
              Text('ব্যালেন্স: ${supplier['balance']}৳', style: TextStyle(color: Colors.red[700], fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(supplier['image'], fit: BoxFit.cover, height: 200),
              ),
              SizedBox(height: 20),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'পরিমাণ লিখুন',
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white70,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() {
                          if (amountController.text.isNotEmpty) supplier['balance'] += int.parse(amountController.text);
                          Navigator.pop(context);
                        });
                      },
                      label: Text('টাকা পেলাম', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.remove),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white70,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() {
                          if (amountController.text.isNotEmpty) supplier['balance'] -= int.parse(amountController.text);
                          Navigator.pop(context);
                        });
                      },
                      label: Text('টাকা দিলাম', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('সাপ্লায়ার পেমেন্ট', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.teal, centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: _filterSupplierList,
              decoration: InputDecoration(
                labelText: 'সার্চ করুন',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final supplier = filteredList[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 6,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(supplier['image'], width: 60, height: 60, fit: BoxFit.cover),
                      ),
                      title: Text(supplier['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      subtitle: Text('${supplier['balance']}৳', style: TextStyle(color: Colors.red[600], fontWeight: FontWeight.bold, fontSize: 16)),
                      onTap: () => _showDetails(index),
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
