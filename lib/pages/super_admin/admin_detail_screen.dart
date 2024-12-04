import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groceryease_delivery_application/pages/super_admin/all_order_screen.dart';

import 'all_product_screen.dart';

class AdminDetailScreen extends StatelessWidget {
  const AdminDetailScreen({required this.adminID, super.key});
  final String adminID;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Detail"),
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              leading: const Icon(CupertinoIcons.cube_box),
              title: const Text("All Products"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllProductsDetail(
                              adminId: adminID,
                            )));
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(CupertinoIcons.shopping_cart),
              title: Text("All Orders"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllOrderScreen(
                              adminId: adminID,
                            )));
              },
            ),
          ),
        ],
      ),
    );
  }
}
