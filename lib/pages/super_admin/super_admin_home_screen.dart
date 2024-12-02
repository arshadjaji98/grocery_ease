import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groceryease_delivery_application/pages/super_admin/all_admin_screen.dart';
import 'package:groceryease_delivery_application/pages/super_admin/all_users_screen.dart';

class SuperAdminHomeScreen extends StatefulWidget {
  const SuperAdminHomeScreen({super.key});

  @override
  State<SuperAdminHomeScreen> createState() => _SuperAdminHomeScreenState();
}

class _SuperAdminHomeScreenState extends State<SuperAdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TabBar Example'),
          actions: [
            IconButton(
              onPressed: ()async{
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
              icon: Icon(Icons.logout),
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(CupertinoIcons.person), text: 'Users'),
              Tab(icon: Icon(CupertinoIcons.shield), text: 'Admin'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AllUsersScreen(),
            AllAdminScreen(),
          ],
        ),
      ),
    );
  }
}
