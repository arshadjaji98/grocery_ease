import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:groceryease_delivery_application/services/database_services.dart';
import 'package:groceryease_delivery_application/services/shared_perf.dart';
import 'package:groceryease_delivery_application/widgets/widget_support.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? id, wallet;
  int total = 0, amount2 = 0;
  Stream? foodStream;

  @override
  void initState() {
    super.initState();
    onLoad();
    startTimer();
  }

  void startTimer() {
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          amount2 = total;
        });
      }
    });
  }

  Future<void> onLoad() async {
    await getSharedPrefs();
    foodStream = await DatabaseServices().getFoodItem("users/$id/Cart");

    // Fetch and calculate total here
    foodStream?.listen((snapshot) {
      int tempTotal = 0;
      for (var doc in snapshot.docs) {
        tempTotal += int.parse(doc["Total"]);
      }

      setState(() {
        total = tempTotal;
      });
    });
  }

  Future<void> getSharedPrefs() async {
    id = await SharedPerfHelper().getUserId();
    wallet = await SharedPerfHelper().getUserWallet();
    setState(() {});
  }

  Future<void> deleteFoodItem(String docId) async {
    await FirebaseFirestore.instance
        .collection("users/$id/Cart")
        .doc(docId)
        .delete();
  }

  Widget foodCart() {
    return StreamBuilder(
        stream: foodStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitDoubleBounce(color: Color(0XFF8a4af3)),
            );
          }

          if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
            return const Center(
              child: Text("No items in the cart"),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];

              return Container(
                margin: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 10.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          height: 90,
                          width: 40,
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(child: Text(ds["Quantity"])),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.network(
                            ds["Image"],
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ds["Name"],
                                style: AppWidgets.semiBoldTextFieldStyle(),
                              ),
                              Text(
                                "\$" + ds["Total"],
                                style: AppWidgets.lightTextFieldStyle(),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            // Delete the item from Firestore
                            await deleteFoodItem(ds.id);
                            // Optionally, you can also refresh the stream to update the UI
                            onLoad();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 2.0,
              child: Container(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Center(
                  child: Text(
                    "Food Cart",
                    style: AppWidgets.headerTextFieldStyle(),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: foodCart(),
            ),
            const Spacer(),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price",
                    style: AppWidgets.boldTextFieldStyle(),
                  ),
                  Text(
                    "\$" + total.toString(),
                    style: AppWidgets.semiBoldTextFieldStyle(),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () async {
                int amount = int.parse(wallet!) - amount2;
                await SharedPerfHelper().saveUserWallet(amount.toString());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: const Color(0XFF8a4af3),
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 20.0),
                child: const Center(
                  child: Text(
                    "CheckOut",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
