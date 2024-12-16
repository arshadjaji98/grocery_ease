import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groceryease_delivery_application/pages/user/order_screen.dart';
import 'package:groceryease_delivery_application/pages/user/profile.dart';
import 'package:groceryease_delivery_application/pages/user/favorite.dart';

import '../home.dart';
import 'order.dart';

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
        return Home(
          image: '',
          name: '',
          details: '',
          price: '',
          id: '',
          adminId: '',
          stock: '',
          type: '',
          favourite: [],
          count: 1,
        );
      case 1:
        return Cart();
      case 2:
        return OrderScreen();
      case 3:
        return Favorite();
      case 4:
        return Profile();
      default:
        return Home(
          image: '',
          name: '',
          details: '',
          price: '',
          id: '',
          adminId: '',
          stock: '',
          type: '',
          favourite: [],
          count: 1,
        );
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
          Icon(CupertinoIcons.home, color: Colors.white),
          Icon(CupertinoIcons.bag, color: Colors.white),
          Icon(CupertinoIcons.cube_box, color: Colors.white),
          Icon(CupertinoIcons.heart, color: Colors.white),
          Icon(CupertinoIcons.person, color: Colors.white)
        ],
      ),
      body: getPage(currentTab),
    );
  }
}
