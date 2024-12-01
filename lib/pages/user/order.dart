import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groceryease_delivery_application/widgets/widget_support.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {

  String selectPayment = "Cash";

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("card").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    double totalAmount = snapshot.data!.docs.fold(0, (sum, doc) {
                      double price = double.parse(doc["price"].toString());
                      int count = int.parse(doc["count"].toString());
                      return sum + (price * count);
                    });
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      snapshot.data!.docs[index]["image"],
                                    ),
                                    radius: 30,
                                  ),
                                  title: Text(snapshot.data!.docs[index]["name"]),
                                  subtitle: Text("Price ${snapshot.data!.docs[index]["price"]}"),
                                  trailing: Text(
                                    "Quantity: ${snapshot.data!.docs[index]["count"].toString()}",
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Amount",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${totalAmount.toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white
                ),
                onPressed: (){
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setModalState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading:
                                const Icon(CupertinoIcons.money_dollar_circle),
                                title: const Text("Cash on Delivery"),
                                trailing: Radio<String>(
                                  value: "Cash",
                                  groupValue: selectPayment,
                                  onChanged: (value) {
                                    setModalState(() {
                                      selectPayment = value!;
                                    });
                                    },
                                ),
                              ),
                              ListTile(
                                leading: const Icon(CupertinoIcons.creditcard),
                                title: const Text("Credit Card"),
                                trailing: Radio<String>(
                                  value: "Credit",
                                  groupValue: selectPayment,
                                  onChanged: (value) {
                                    setModalState(() {
                                      selectPayment = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                child: Text("Continue"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
