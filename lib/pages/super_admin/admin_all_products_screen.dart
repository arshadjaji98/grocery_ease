import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:groceryease_delivery_application/widgets/widget_support.dart';

class AdminAllProductsScreen extends StatefulWidget {
  const AdminAllProductsScreen({super.key});

  @override
  State<AdminAllProductsScreen> createState() => _AdminAllProductsScreenState();
}

class _AdminAllProductsScreenState extends State<AdminAllProductsScreen> {
  List<String> types = ["Fruit", "Meat", "Backery", "Beverages", "Oil"];
  String? selectType;

  Future<void> _deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection("products")
          .doc(productId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Product deleted successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete product: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("products")
          .where("type", isEqualTo: selectType)
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: SpinKitWave(color: Color(0XFF8a4af3), size: 30.0));
        }
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return const Center(
              child: Text("No items available",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)));
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
              child: Material(
                elevation: 5,
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: ds["image"],
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              LinearProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ds["name"],
                                style: AppWidgets.semiBoldTextFieldStyle()),
                            const SizedBox(height: 5),
                            Text("Fresh and Healthy",
                                style: AppWidgets.lightTextFieldStyle()),
                            const SizedBox(height: 5),
                            Text("\$${ds["price"]}",
                                style: AppWidgets.semiBoldTextFieldStyle()),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteDialog(ds.id);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(String productId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Product"),
          content: const Text("Are you sure you want to delete this product?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel", style: AppWidgets.lightTextFieldStyle()),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteProduct(productId); // Delete the product
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: Text(
                "Delete",
                style: AppWidgets.semiBoldTextFieldStyle(),
              ),
            ),
          ],
        );
      },
    );
  }
}
