import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:groceryease_delivery_application/pages/home.dart';
import 'package:groceryease_delivery_application/pages/order.dart';
import 'package:groceryease_delivery_application/pages/profile.dart';
import 'package:groceryease_delivery_application/pages/wallet.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTab = 0;

  // This function creates a new instance for each screen when called.
  Widget getPage(int index) {
    switch (index) {
      case 0:
        return Home();
      case 1:
        return Order();
      case 2:
        return Wallet();
      case 3:
        return Profile();
      default:
        return Home();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Color(0XFF8a4af3),
        animationDuration: Duration(milliseconds: 300),
        onTap: (int index) {
          setState(() {
            currentTab = index;
          });
        },
        items: [
          Icon(Icons.home_outlined, color: Colors.white),
          Icon(Icons.shopping_bag_outlined, color: Colors.white),
          Icon(Icons.wallet_outlined, color: Colors.white),
          Icon(Icons.person_outlined, color: Colors.white)
        ],
      ),
      body: getPage(currentTab),
    );
  }
}
