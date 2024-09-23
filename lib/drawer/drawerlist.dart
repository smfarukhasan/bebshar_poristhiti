import 'package:flutter/material.dart';
import 'package:bebshar_poristhiti/screens/home_page.dart';
import 'package:bebshar_poristhiti/screens/cash/cash.dart';
import 'package:bebshar_poristhiti/screens/products/add_products.dart';
import 'package:bebshar_poristhiti/screens/purchase/purchase.dart';
import 'package:bebshar_poristhiti/screens/sale/sale.dart';
import 'package:bebshar_poristhiti/screens/supplier/supplier.dart';
import 'package:bebshar_poristhiti/screens/customer/customer.dart';
import 'package:bebshar_poristhiti/screens/expense/expense.dart';
import 'package:bebshar_poristhiti/screens/report/purchase_report.dart';
import 'package:bebshar_poristhiti/screens/report/sale_report.dart';
import 'package:bebshar_poristhiti/screens/stock/stock.dart';
import 'package:bebshar_poristhiti/screens/settings/theme/theme.dart';
import 'package:bebshar_poristhiti/screens/settings/user_profile.dart';
import 'package:bebshar_poristhiti/screens/settings/change_pin.dart';
import 'package:bebshar_poristhiti/screens/settings/language.dart';

class DrawerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('Home'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        ListTile(
          title: Text('Cash Box'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Cash()),
            );
          },
        ),
        ListTile(
          title: Text('Products'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AddProducts()),
            );
          },
        ),
        ListTile(
          title: Text('Purchase'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Purchase()),
            );
          },
        ),
        ListTile(
          title: Text('Sale'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Sale()),
            );
          },
        ),
        ListTile(
          title: Text('Supplier'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Supplier()),
            );
          },
        ),
        ListTile(
          title: Text('Customer'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Customer()),
            );
          },
        ),
        ListTile(
          title: Text('Expense'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Expense()),
            );
          },
        ),
        ListTile(
          title: Text('Report'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PurchaseReport()),
            );
          },
        ),
        ListTile(
          title: Text('Stock'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Stock()),
            );
          },
        ),
        ListTile(
          title: Text('Settings'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Theme()),
            );
          },
        ),
      ],
    );
  }
}