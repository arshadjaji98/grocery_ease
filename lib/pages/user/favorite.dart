import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/card_box_widget.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {



  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Favourite"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.hasData && userSnapshot.data!.exists) {
            // Get the favourite list from the user's document
            List<dynamic> favouriteIds = userSnapshot.data!["favourite"] ?? [];

            if (favouriteIds.isEmpty) {
              return Center(
                child: Text("No favourite products found."),
              );
            }

            // Query the products collection based on the favourite IDs
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("products")
                  .where(FieldPath.documentId, whereIn: favouriteIds)
                  .snapshots(),
              builder: (context, productSnapshot) {
                if (productSnapshot.hasData) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 6 / 7.5,
                    ),
                    itemCount: productSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var product = productSnapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: CardBox(
                          imageUrl: product["image"],
                          title: product["name"].toString(),
                          price: product["price"].toString(),
                          count: product["quantity"].toString(),
                          icon: product["favourite"].contains(FirebaseAuth.instance.currentUser!.uid) ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({
                              "favourite": FieldValue.arrayRemove([product.id]),
                            });
                            FirebaseFirestore.instance.collection("products").doc(product["id"]).update({
                              "favourite" : FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid.toString()]),
                            });
                          },
                          onTap: () {
                            // Handle product tap
                          },
                        ),
                      );
                    },
                  );
                } else if (productSnapshot.hasError) {
                  return Center(
                    child: Text("Error fetching favourite products."),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      )

    );
  }
}
