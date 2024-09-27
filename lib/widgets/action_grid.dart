import 'package:flutter/material.dart';
import '../personal_expense.dart';
import '../product_page.dart';
import '../sale_history_page.dart';
import '../purchase_history_page.dart';
import '../stock_management_page.dart';
import '../contact_management_page.dart';

class ActionGrid extends StatelessWidget {
  final BuildContext context;
  final double screenWidth;
  final double screenHeight;

  ActionGrid(this.context, this.screenWidth, this.screenHeight);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildGridItem(Icons.shopping_bag, 'ক্রয় সমূহ', PurchaseHistoryPage(), Colors.blue),
        _buildGridItem(Icons.shopping_cart, 'বিক্রয় সমূহ', SaleHistoryPage(), Colors.green),
        _buildGridItem(Icons.store, 'স্টক', StockManagementPage(), Colors.cyan),
        _buildGridItem(Icons.inventory, 'প্রোডাক্ট', ProductPage(), Colors.brown),
        _buildGridItem(Icons.people, 'সকল পার্টি', ContactManagementPage(), Colors.red),
        _buildGridItem(Icons.note_alt, 'খরচের হিসাব', PersonalExpensePage(), Colors.teal),
      ],
    );
  }

  Widget _buildGridItem(IconData icon, String label, Widget? page, Color color) {
    return InkWell(
      onTap: () {
        if (page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        }
      },
      child: Card(
        color: color, // Use the passed color here
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50),
            SizedBox(height: 10),
            Text(label, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
