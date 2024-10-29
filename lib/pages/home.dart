// ignore_for_file: override_on_non_overriding_member
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groceryease_delivery_application/pages/details.dart';
import 'package:groceryease_delivery_application/services/database_services.dart';
import 'package:groceryease_delivery_application/widgets/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Stream? fooditemStream;
  bool fruit = false;
  bool meat = false;
  bool backery = false;
  bool beverages = false;
  bool oil = false;
  ontheload() async {
    fooditemStream = await DatabaseServices().getFoodItem('Fruit');
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  Widget allItemsVertically() {
    return StreamBuilder(
      stream: fooditemStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(child: Text("No items available"));
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Details(
                            image: ds['Image'],
                            name: ds['Name'],
                            details: ds['Detail'],
                            price: ds['Price'],
                          )),
                );
              },
              child: Container(
                margin: EdgeInsets.only(right: 20, bottom: 20),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            ds["Image"],
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ds["Name"],
                                style: AppWidgets.semiBoldTextFieldStyle()),
                            SizedBox(height: 5),
                            Text("Fresh and Healthy",
                                style: AppWidgets.lightTextFieldStyle()),
                            SizedBox(height: 5),
                            Text("\$${ds["Price"]}",
                                style: AppWidgets.semiBoldTextFieldStyle()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget allItems() {
    return StreamBuilder(
      stream: fooditemStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(child: Text("No items available"));
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Details(
                            image: ds['Image'],
                            name: ds['Name'],
                            details: ds['Detail'],
                            price: ds['Price'],
                          )),
                );
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            ds["Image"],
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(ds["Name"],
                            style: AppWidgets.semiBoldTextFieldStyle()),
                        Text("Fresh and Healthy",
                            style: AppWidgets.lightTextFieldStyle()),
                        Text("\$${ds["Price"]}",
                            style: AppWidgets.semiBoldTextFieldStyle()),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(top: 50, left: 10),
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        fooditemStream =
                            await DatabaseServices().getFoodItem("Fruit");
                        fruit = true;
                        meat = false;
                        backery = false;
                        beverages = false;
                        oil = false;
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: fruit
                                ? Colors.white
                                : Color(0xff53B175).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Color(0xff53B175))),
                        child: Column(
                          children: [
                            Image.asset('assets/images/fruits.png',
                                height: 100, width: 100),
                            Text("Fruits & \nVegetables",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: 'Poppins'))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () async {
                        fooditemStream =
                            await DatabaseServices().getFoodItem("Backery");
                        fruit = false;
                        meat = false;
                        backery = true;
                        beverages = false;
                        oil = false;
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: backery
                                ? Colors.white
                                : Color(0xffD3B0E0).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Color(0xffD3B0E0))),
                        child: Column(
                          children: [
                            Image.asset('assets/images/backery.png',
                                height: 100, width: 100),
                            Text("Bakery\n Snacks",
                                style: TextStyle(fontFamily: 'Poppins'))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () async {
                        fooditemStream =
                            await DatabaseServices().getFoodItem("Beverages");
                        fruit = false;
                        meat = false;
                        backery = false;
                        beverages = true;
                        oil = false;
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: beverages
                                ? Colors.white
                                : Color(0xffB7DFF5).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Color(0xffB7DFF5))),
                        child: Column(
                          children: [
                            Image.asset('assets/images/beverages.png',
                                height: 100, width: 100),
                            Text("Beverages\n",
                                style: TextStyle(fontFamily: 'Poppins'))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () async {
                        fooditemStream =
                            await DatabaseServices().getFoodItem("Meat");
                        fruit = false;
                        meat = true;
                        backery = false;
                        beverages = false;
                        oil = false;
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: meat
                                ? Colors.white
                                : Color(0xffF7A593).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Color(0xffF7A593))),
                        child: Column(
                          children: [
                            Image.asset('assets/images/meat.png',
                                height: 100, width: 100),
                            Text("Meat & Fish\n",
                                style: TextStyle(fontFamily: 'Poppins'))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () async {
                        fooditemStream =
                            await DatabaseServices().getFoodItem("oil");
                        fruit = false;
                        meat = false;
                        backery = false;
                        beverages = false;
                        oil = true;
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: oil
                                ? Colors.white
                                : Color(0xffF8A44C).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Color(0xffF8A44C))),
                        child: Column(
                          children: [
                            Image.asset('assets/images/oil.png',
                                height: 100, width: 100),
                            Text("Cooking Oil\n",
                                style: TextStyle(fontFamily: 'Poppins'))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                height: 300,
                child: allItems(),
              ),
              SizedBox(height: 30),
              allItemsVertically()
            ],
          ),
        ),
      ),
    );
  }
}
