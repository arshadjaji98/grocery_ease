import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groceryease_delivery_application/services/shared_perf.dart';
import 'package:groceryease_delivery_application/widgets/widget_support.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<String> favoriteItems = [];

  Future<void> getFavorites() async {
    String? userId = await SharedPerfHelper().getUserId();
    final favoritesRef =
        FirebaseFirestore.instance.collection('favorites').doc(userId);
    final docSnapshot = await favoritesRef.get();

    if (docSnapshot.exists) {
      setState(() {
        favoriteItems = List<String>.from(docSnapshot.data()?['items'] ?? []);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getFavorites(); // Load the favorite items when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 60),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                elevation: 2,
                child: Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: Text(
                      "Favorites",
                      style: AppWidgets.headerTextFieldStyle(),
                    ),
                  ),
                ),
              ),
              if (favoriteItems.isEmpty)
                Center(child: Text("No favorites added yet."))
              else
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: favoriteItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(favoriteItems[index]),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
