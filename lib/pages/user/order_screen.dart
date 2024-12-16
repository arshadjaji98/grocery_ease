import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groceryease_delivery_application/widgets/widget_support.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Your Orders", style: AppWidgets.boldTextFieldStyle()),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("orders")
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No orders found"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DateTime dateTime =
                  (snapshot.data!.docs[index]["timestamp"] as Timestamp)
                      .toDate();
              var orderDate = DateFormat('dd-MM-yyyy').format(dateTime);
              return Card(
                child: ExpansionTile(
                  title: Text(orderDate,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                          color: Colors.grey)),
                  subtitle: Text(snapshot.data!.docs[index]["paymentMethod"],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black)),
                  trailing: Text(
                      "Rs. " +
                          snapshot.data!.docs[index]["totalAmount"].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black)),
                  children: [
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs[index]["items"].length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            leading: Text("${i + 1}"),
                            title: Text(
                              snapshot.data!.docs[index]["items"][i]["name"],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            subtitle: Text(snapshot.data!.docs[index]["items"]
                                [i]["orderType"]),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Rs. " +
                                    snapshot.data!.docs[index]["items"][i]
                                        ["price"]),
                                Text("Qty. " +
                                    snapshot
                                        .data!.docs[index]["items"][i]["count"]
                                        .toString()),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
