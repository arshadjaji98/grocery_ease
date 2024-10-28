// ignore_for_file: override_on_non_overriding_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groceryease_delivery_application/pages/details.dart';
import 'package:groceryease_delivery_application/services/database_services.dart';
import 'package:groceryease_delivery_application/widgets/show_item.dart';
import 'package:groceryease_delivery_application/widgets/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Stream? fooditemStream;
  ontheload() async {
    fooditemStream = await DatabaseServices().getFoodItem('Fruit');
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  Widget allItems() {
    return StreamBuilder(
        stream: fooditemStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Details()));
                      },
                      child: Container(
                        margin: EdgeInsets.all(4),
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(ds["Image"],
                                    height: 150, width: 150, fit: BoxFit.cover),
                                Text(ds["Name"],
                                    style: AppWidgets.semiBoldTextFieldStyle()),
                                Text(ds["Detail"],
                                    style: AppWidgets.lightTextFieldStyle()),
                                Text("\$" + ds["Price"],
                                    style: AppWidgets.semiBoldTextFieldStyle()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : CircularProgressIndicator();
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: 50, left: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hello and Welcome!",
                    style: AppWidgets.boldTextFieldStyle(),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    child:
                        Icon(Icons.shopping_cart_outlined, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Delicious Food",
                style: AppWidgets.headerTextFieldStyle(),
              ),
              Text(
                "Discover and Get Great Food",
                style: AppWidgets.lightTextFieldStyle(),
              ),
              SizedBox(height: 20),
              ShowItem(),
              SizedBox(height: 30),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Details()));
                      },
                      child: Container(
                        margin: EdgeInsets.all(4),
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/dish.png',
                                    height: 150, width: 150, fit: BoxFit.cover),
                                Text("Half Fry",
                                    style: AppWidgets.semiBoldTextFieldStyle()),
                                Text("Fresh and Healthy",
                                    style: AppWidgets.lightTextFieldStyle()),
                                Text("\$25",
                                    style: AppWidgets.semiBoldTextFieldStyle()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      margin: EdgeInsets.all(4),
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/pringle.png',
                                  height: 150, width: 150, fit: BoxFit.cover),
                              Text("Hot Chips",
                                  style: AppWidgets.semiBoldTextFieldStyle()),
                              Text("Packed with ketchup",
                                  style: AppWidgets.lightTextFieldStyle()),
                              Text("\$10",
                                  style: AppWidgets.semiBoldTextFieldStyle()),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Details()));
                },
                child: Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/cheese.png',
                              width: 120, height: 120),
                          SizedBox(width: 20),
                          Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text("NIDO Milk",
                                    style: AppWidgets.semiBoldTextFieldStyle()),
                              ),
                              SizedBox(height: 5),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text("Fresh Milk Powder",
                                    style: AppWidgets.lightTextFieldStyle()),
                              ),
                              SizedBox(height: 5),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text("\$10",
                                    style: AppWidgets.semiBoldTextFieldStyle()),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
