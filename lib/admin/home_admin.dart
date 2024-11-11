import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groceryease_delivery_application/admin/add_food.dart';
import 'package:groceryease_delivery_application/admin/admin_login.dart';
import 'package:groceryease_delivery_application/admin/chats.dart';
import 'package:groceryease_delivery_application/admin/my_products.dart';
import 'package:groceryease_delivery_application/widgets/widget_support.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  String? storeName;

  @override
  void initState() {
    super.initState();
    fetchStoreName();
  }

  Future<void> fetchStoreName() async {
    try {
      final email = FirebaseAuth.instance.currentUser?.email;
      if (email != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection("Admin")
            .where("email", isEqualTo: email)
            .get();

        if (snapshot.docs.isNotEmpty) {
          setState(() {
            storeName = snapshot.docs.first["id"];
          });
        }
      }
    } catch (e) {
      print("Error fetching store name: $e");
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const AdminLogin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home Admin"),
      ),
      drawer: SafeArea(
        child: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Text(
                  storeName ?? "Loading...", // Display the store name here
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.add,
                  color: Color(0XFF8a4af3),
                ),
                title: const Text('Add Product',
                    style: TextStyle(
                      color: Color(0XFF8a4af3),
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddFood()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.chat_outlined,
                  color: Color(0XFF8a4af3),
                ),
                title: const Text('Chat Screen',
                    style: TextStyle(
                      color: Color(0XFF8a4af3),
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminChatScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.inventory,
                  color: Color(0XFF8a4af3),
                ),
                title: const Text('My Products',
                    style: TextStyle(
                      color: Color(0XFF8a4af3),
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyProducts()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Color(0XFF8a4af3),
                ),
                title: const Text('Logout',
                    style: TextStyle(
                      color: Color(0XFF8a4af3),
                    )),
                onTap: signOut,
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your Orders",
              style: AppWidgets.boldTextFieldStyle(),
            )
          ],
        ),
      ),
    );
  }
}
