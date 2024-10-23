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
  late List<Widget> pages;
  late Widget currentPage;
  late Home homePage;
  late Profile profile;
  late Order order;
  late Wallet wallet;

  @override
  void initState() {
    homePage = Home();
    profile = Profile();
    order = Order();
    wallet = Wallet();
    currentPage = homePage;
    pages = [homePage, profile, order, wallet];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: Duration(milliseconds: 300),
        onTap: (int index) {
          setState(() {
            currentTab = index;
            currentPage = pages[currentTab];
          });
        },
        items: [
          Icon(Icons.home_outlined, color: Colors.white),
          Icon(Icons.shopping_bag_outlined, color: Colors.white),
          Icon(Icons.wallet_outlined, color: Colors.white),
          Icon(Icons.person_outlined, color: Colors.white)
        ],
      ),
      body: pages[currentTab],
    );
  }
}
